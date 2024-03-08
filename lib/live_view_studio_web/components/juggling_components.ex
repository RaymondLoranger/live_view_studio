defmodule LiveView.StudioWeb.JugglingComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  attr :window_keyup, :string, required: true
  slot :inner_block, required: true

  @spec juggling(Socket.assigns()) :: Rendered.t()
  def juggling(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div
      id={@id}
      phx-window-keyup={@window_keyup}
      class="mx-auto max-w-sm rounded-lg shadow-lg"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :text, :string, required: true

  def legend(assigns) do
    ~H"""
    <div class="text-cool-gray-700 border-cool-gray-300 rounded-t-lg border-2 border-b-0 py-3 text-center text-lg font-medium">
      <%= @text %>
    </div>
    """
  end

  attr :current, :integer, required: true

  def current_image(assigns) do
    ~H"""
    <img
      src={"/images/juggling/juggling-#{pad(@current)}.jpg"}
      class="border-cool-gray-300 border-2"
    />
    """
  end

  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <div class="text-cool-gray-800 border-cool-gray-300 flex justify-between rounded-b-lg border-2 border-t-0 px-3 py-2 text-lg">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :current, :integer, required: true

  def current_file(assigns) do
    ~H"""
    <span class="text-cool-gray-800 tabular-nums">
      <%= "juggling-#{pad(@current)}.jpg" %>
    </span>
    """
  end

  attr :value, :string, required: true
  attr :keyup, :string, required: true
  attr :key, :string, required: true
  attr :error, :string, required: true

  def input_field(assigns) do
    ~H"""
    <div class="w-1/4">
      <input
        id="current-number"
        type="number"
        value={@value}
        phx-keyup={@keyup}
        phx-key={@key}
        phx-mounted={JS.focus()}
        min="0"
        max="18"
        class="border-cool-gray-500 text-cool-gray-700 h-8 rounded border px-3 py-2 focus:ring-cool-gray-500 focus:border-none focus:ring-2"
      />
      <div class="ml-0.5 text-sm tracking-tighter text-red-600">
        <span class="-mt-1 mb-1"><%= @error %></span>
      </div>
    </div>
    """
  end

  attr :click, :string, required: true
  attr :timer, :any, required: true, doc: "A timer reference actually..."

  def mode_button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      class="py-auto border-cool-gray-400 text-cool-gray-700 mx-1 h-8 w-1/4 rounded-lg border-2 bg-transparent px-4 shadow-sm outline-none transition duration-150 ease-in-out hover:bg-cool-gray-300 focus:border-cool-gray-500"
    >
      <%= if @timer, do: "Pause", else: "Play" %>
    </button>
    """
  end

  ## Private functions

  # 0 => "00" and 18 => "18"
  @spec pad(non_neg_integer) :: String.t()
  defp pad(number), do: String.pad_leading("#{number}", 2, "0")
end
