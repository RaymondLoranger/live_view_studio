defmodule LiveView.StudioWeb.ServerNamesLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import ServersComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()
    servers = Servers.list_servers_by_asc_name()

    {:ok,
     socket
     |> stream(:servers, servers)
     |> assign(:selected_server, hd(servers))}
  end

  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(%{"name" => name}, _uri, socket) do
    server = Servers.get_server_by_name(name)

    {:noreply,
     socket
     |> push_event("switch-selected-server", %{
       old_id: dom_id(socket.assigns.selected_server),
       new_id: dom_id(server)
     })
     |> assign(
       selected_server: server,
       page_title: "What's up #{server.name}?"
     )}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, page_title: "Server Names")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="server-names-focus-wrap">
      <.servers id="server-names" header="📥 Server Names 📤">
        <.sidebar id="sidebar" mounted={JS.focus_first()}>
          <.navbar id="navbar" update="stream" hook="SelectedServer">
            <.server_link
              :for={{server_id, server} <- @streams.servers}
              id={server_id}
              patch={~p"/server-names/#{server.name}"}
              selected_server={@selected_server}
              server={server}
            />
          </.navbar>
        </.sidebar>

        <.main>
          <.live_component
            :if={@selected_server}
            module={ServerLayout}
            id="server-layout"
            server={@selected_server}
          />
        </.main>
      </.servers>
    </.focus_wrap>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:server_created, server}, socket) do
    {:noreply,
     socket
     |> stream_insert(:servers, server, at: 0)
     |> push_patch(to: ~p"/server-names/#{server.name}")}
  end

  def handle_info({:server_updated, server}, socket) do
    {:noreply,
     socket
     |> stream_insert(:servers, server)
     |> push_patch(to: ~p"/server-names/#{server.name}")}
  end

  def handle_info({:server_deleted, server}, socket) do
    {:noreply,
     socket
     |> stream_delete(:servers, server)
     |> assign(:selected_server, nil)
     |> push_patch(to: ~p"/server-names")}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "::: Unexpected msg ::")
    {:noreply, socket}
  end
end
