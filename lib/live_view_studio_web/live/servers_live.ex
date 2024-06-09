defmodule LiveView.StudioWeb.ServersLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import ServersComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()
    servers = Servers.list_servers_by_desc_id()

    {:ok,
     socket
     |> stream(:servers, servers)
     |> assign(:selected_server, hd(servers))}
  end

  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="servers-focus-wrap">
      <.servers id="servers" header="Servers 🖧">
        <.sidebar id="sidebar" mounted={JS.focus_first()}>
          <:add_server>
            <.add_server_link
              patch={~p"/servers/new/form"}
              label="+ Add Server via Form"
            />
            <.add_server_link
              patch={~p"/servers/new/modal"}
              label="+ Add Server via Modal"
            />
          </:add_server>

          <.navbar id="navbar" update="stream" hook="SelectedServer">
            <.server_link
              :for={{server_id, server} <- @streams.servers}
              id={server_id}
              patch={~p"/servers/#{server}"}
              selected_server={@selected_server}
              server={server}
            />
          </.navbar>
        </.sidebar>

        <.main>
          <.live_component
            :if={@live_action == :form_new}
            module={ServerForm}
            id="server-form"
            on_cancel={route(@selected_server)}
          />

          <.modal
            :if={@live_action == :modal_new}
            id="server-form-modal"
            show={true}
            on_cancel={route(@selected_server) |> JS.patch()}
            outer_class="bg-white/10"
            inner_class="-mt-20 ml-20 bg-cool-gray-200/90 pb-0 min-w-max max-w-xl"
          >
            <.live_component
              module={ServerForm}
              id="server-form"
              inside_modal={true}
              on_cancel={route(@selected_server)}
              class="!border-none !shadow-none"
            />
          </.modal>

          <.live_component
            :if={@live_action in [nil, :modal_new] and @selected_server}
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
  def handle_info({Servers, :server_created, server}, socket) do
    {:noreply,
     socket
     #  Prepend new server...
     |> stream_insert(:servers, server, at: 0)
     |> push_patch(to: ~p"/servers/#{server}")}
  end

  def handle_info({Servers, :server_updated, server}, socket) do
    {:noreply,
     socket
     |> stream_insert(:servers, server)
     |> push_patch(to: ~p"/servers/#{server}")}
  end

  def handle_info({Servers, :server_deleted, server}, socket) do
    {:noreply,
     socket
     |> stream_delete(:servers, server)
     |> assign(:selected_server, nil)
     |> push_patch(to: ~p"/servers")}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "::: Unexpected msg ::")
    {:noreply, socket}
  end

  ## Private functions

  @spec apply_action(Socket.t(), atom, LV.unsigned_params()) :: Socket.t()
  defp apply_action(socket, action, _params)
       when action in [:form_new, :modal_new] do
    assign(socket, page_title: "New Server")
  end

  defp apply_action(socket, _action = nil, _params = %{"id" => id}) do
    server = Servers.get_server!(id)

    socket
    |> push_event("switch-selected-server", %{
      old_id: dom_id(socket.assigns.selected_server),
      new_id: dom_id(server)
    })
    |> assign(
      selected_server: server,
      page_title: "What's up #{server.name}?"
    )
  end

  defp apply_action(socket, _action = nil, _params) do
    assign(socket, page_title: "Servers")
  end

  @spec route(%Server{} | nil) :: Path.t()
  defp route(nil), do: ~p"/servers"
  defp route(server), do: ~p"/servers/#{server}"
end
