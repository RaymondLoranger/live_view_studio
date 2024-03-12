defmodule LiveView.StudioWeb.ChartComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  slot :inner_block, required: true

  @spec chart(Socket.assigns()) :: Rendered.t()
  def chart(assigns) do
    ~H"""
    <div id="chart" class="mx-auto max-w-full">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :text, :string, required: true

  def canvas_header(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @text %>
    </.header>
    """
  end

  attr :update, :string, required: true
  slot :inner_block, required: true

  def canvas_wrapper(assigns) do
    ~H"""
    <div id="canvas-wrapper" phx-update={@update}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :hook, :string, required: true
  attr :chart, :string, required: true

  def canvas(assigns) do
    ~H"""
    <canvas id="canvas" phx-hook={@hook} data-chart={@chart} />
    """
  end

  slot :inner_block, required: true

  def canvas_footer(assigns) do
    ~H"""
    <div id="canvas-footer" class="text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :click, :string, required: true

  def chart_button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      class="mt-4 rounded bg-indigo-500 px-4 py-2 font-medium text-white outline-none hover:bg-indigo-700 active:bg-indigo-500"
    >
      Get Reading
    </button>
    """
  end

  attr :last_label, :string, required: true

  def total_readings(assigns) do
    ~H"""
    <div class="my-2">
      Total readings: <%= @last_label %>
    </div>
    """
  end
end
