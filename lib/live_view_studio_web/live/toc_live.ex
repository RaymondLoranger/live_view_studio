defmodule LiveView.StudioWeb.TOCLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import TOCComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, dep: "", deps: [], page_title: "Table of Contents")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.welcome_section>
      <.dep_search_form change="change" submit="go_hex">
        <.dep_field dep={@dep} deps={@deps} />
        <.go_button />
      </.dep_search_form>
    </.welcome_section>
    <.toc_section socket={@socket} />
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("change", %{"dep" => dep}, socket) do
    {:noreply, assign(socket, deps: search(dep), dep: dep)}
  end

  def handle_event("go_hex", %{"dep" => dep}, socket) do
    # Pretend it takes a while...
    # :timer.sleep(500)

    case search(dep) do
      %{^dep => {_desc, vsn}} ->
        external = "https://hexdocs.pm/#{dep}/#{vsn}"
        {:noreply, redirect(socket, external: external)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, ~s|Dependency "#{dep}" not found in HexDocs|)
         |> assign(deps: [], dep: dep)}
    end
  end

  ## Private functions

  @spec search(String.t()) :: %{String.t() => {String.t(), charlist}}
  defp search(dep) do
    unless Endpoint.config(:code_reloader),
      do: raise("action disabled when not in development")

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, dep),
        # Reject any Erlang Runtime System (ERTS) applications...
        !List.starts_with?(desc, ~c"ERTS"),
        desc = to_string(desc),
        into: %{},
        do: {app, {desc, vsn}}
  end
end
