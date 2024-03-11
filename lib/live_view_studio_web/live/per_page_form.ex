defmodule LiveView.StudioWeb.PerPageForm do
  use LiveView.StudioWeb, [:live_component, :imports, :aliases]

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article
      id={"#{@id}-component"}
      phx-target={@myself}
      phx-window-keydown="paginate"
      phx-throttle="300"
    >
      <form
        id={@id}
        phx-change="select-per-page"
        phx-target={@myself}
        class="mb-4 flex items-center justify-end"
      >
        Show
        <select
          name="per-page"
          onKeyDown="return !['ArrowLeft', 'ArrowRight'].includes(event.key);"
          class="bg-cool-gray-200 border-cool-gray-400 text-cool-gray-700 mx-1 w-14 cursor-pointer appearance-none rounded-lg border px-2 py-1 text-sm font-semibold leading-tight hover:border-indigo-500 hover:bg-indigo-200 focus:bg-blue-200 focus:outline-none"
        >
          <%= options_for_select([5, 10, 15, 20], @options.per_page) %>
        </select>
        <label for="per-page">per page</label>
      </form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    options = %{socket.assigns.options | per_page: String.to_integer(per_page)}
    {:noreply, push_patch(socket, to: socket.assigns.route.(options))}
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    options = socket.assigns.options
    options = update_in(options.page, &max(1, &1 - 1))
    {:noreply, push_patch(socket, to: socket.assigns.route.(options))}
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    options = socket.assigns.options
    max_page = ceil(socket.assigns.total / options.per_page)
    options = update_in(options.page, &min(max_page, &1 + 1))
    {:noreply, push_patch(socket, to: socket.assigns.route.(options))}
  end

  # Catch-all clause for other keys.
  def handle_event("paginate", %{"key" => key}, socket) do
    IO.inspect(key, label: "::: key ignored ::")
    {:noreply, socket}
  end
end
