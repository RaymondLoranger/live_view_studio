defmodule LiveView.StudioWeb.ServerLayout do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import ServersComponents

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.server_layout id={@id}>
        <.server_header id="server-header">
          <.server_name id="server-name" name={@server.name} />
          <.toggle_button
            click="toggle-status"
            id={@server.id}
            disable_with="..."
            target={@myself}
            status={@server.status}
          />
          <.delete_icon click="delete" id={@server.id} target={@myself} />
        </.server_header>

        <.server_body id="server-body" server={@server} />
      </.server_layout>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("toggle-status", %{"id" => id}, socket) do
    {:ok, _server} = Servers.toggle_status_server!(id)
    # Wait to see swapped text during event submission...
    # :timer.sleep(250)
    # Parent's handle_info/2 will call push_patch/2...
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _server} = Servers.delete_server!(id)
    {:noreply, socket}
  end
end
