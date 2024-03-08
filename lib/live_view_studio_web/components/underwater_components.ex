defmodule LiveView.StudioWeb.UnderwaterComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec underwater(Socket.assigns()) :: Rendered.t()
  def underwater(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <% @header %>
    </.header>

    <div id={@id} class="mx-auto max-w-xl text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :to, :string, required: true
  attr :mounted, JS, default: %JS{}
  attr :text, :string, required: true

  def sea_button(assigns) do
    ~H"""
    <.link
      patch={@to}
      phx-mounted={@mounted}
      class="border border-purple-500 focus:outline-none text-white bg-purple-400 hover:bg-purple-500 focus:ring-2 focus:ring-purple-50 font-medium rounded-lg text-sm px-5 py-2.5 mb-2 dark:bg-purple-300 dark:hover:bg-purple-400 dark:focus:ring-purple-600 active:ring-4"
    >
      <%= @text %>
    </.link>
    """
  end

  slot :inner_block, required: true

  def sea_creatures(assigns) do
    ~H"""
    <h2 class="mt-6 text-2xl font-bold">
      Sea Creatures
    </h2>

    <div class="my-6 text-center text-2xl">
      🐙 🐳 🦑 🐡 🐚 🐋 🐟 🦈 🐠 🦀 🐬
    </div>

    <div class="mb-6">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
