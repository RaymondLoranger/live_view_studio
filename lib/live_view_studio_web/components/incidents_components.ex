defmodule LiveView.StudioWeb.IncidentsComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  slot :inner_block, required: true

  @spec mapping(Socket.assigns()) :: Rendered.t()
  def mapping(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      Nearby Incidents
    </.header>

    <div id="mapping" class="flex">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def incidents(assigns) do
    ~H"""
    <div
      id="sidebar"
      phx-update={@update}
      class="h-[575px] w-1/3 overflow-auto shadow-md"
    >
      <%= for incident <- @incidents do %>
        <%= render_slot(@inner_block, incident) %>
      <% end %>
    </div>
    """
  end

  # See 'tailwind.config.js' for variant 'selected'.
  def incident(assigns) do
    ~H"""
    <div
      selected={@selected}
      phx-click={@click}
      phx-value-id={@incident.id}
      class="border-cool-gray-300 text-cool-gray-800 border-b bg-white p-4 text-base font-bold selected:bg-yellow-100 hover:cursor-pointer hover:bg-indigo-200"
    >
      <%= @incident.description %>
    </div>
    """
  end

  slot :inner_block, required: true

  def map_view(assigns) do
    ~H"""
    <div id="view" class="ml-6 w-2/3">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def map_wrapper(assigns) do
    ~H"""
    <div id="wrapper" phx-update={@update}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def map(assigns) do
    ~H"""
    <div id="map" phx-hook={@hook} class="h-[575px]" />
    """
  end

  slot :inner_block, required: true

  def button_wrapper(assigns) do
    ~H"""
    <div class="text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def map_button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      class="mt-6 rounded bg-indigo-500 px-4 py-2 font-medium text-white outline-none hover:bg-indigo-700 active:bg-indigo-500"
    >
      Report Incident
    </button>
    """
  end
end
