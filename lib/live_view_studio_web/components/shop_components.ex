defmodule LiveView.StudioWeb.ShopComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec shop(Socket.assigns()) :: Rendered.t()
  def shop(assigns) do
    ~H"""
    <.header inner_class="text-cool-gray-900 mb-6 text-center text-4xl font-extrabold">
      <%= @header %>
    </.header>

    <section id={@id} class="mx-auto mt-8 max-w-3xl text-center">
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  slot :inner_block, required: true

  def cart_summary(assigns) do
    ~H"""
    <div class="-mt-8 flex h-6 items-center justify-end">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :click, :string, required: true
  slot :inner_block, required: true

  def show_cart_button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      id="show-cart-button"
      title="Show Cart"
      class="cursor-pointer rounded-md border-2 border-transparent bg-transparent px-3 py-1 hover:border-slate-300"
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :count, :integer, required: true

  def cart_count(assigns) do
    ~H"""
    <span class="ml-1 inline-block rounded-full bg-slate-600 px-2 py-1 text-xs font-bold tabular-nums text-white">
      <%= @count %>
    </span>
    """
  end

  slot :inner_block, required: true

  def products(assigns) do
    ~H"""
    <div class="mt-4 grid grid-cols-2 gap-6 sm:grid-cols-3">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def product(assigns) do
    ~H"""
    <div class="max-w-sm overflow-hidden rounded border-4 border-transparent bg-white p-3 shadow-lg">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :image, :string, required: true

  def product_image(assigns) do
    ~H"""
    <div class="mb-2 text-center text-5xl">
      <%= @image %>
    </div>
    """
  end

  attr :name, :string, required: true

  def product_name(assigns) do
    ~H"""
    <div class="mb-6 text-center text-lg font-medium text-slate-900">
      <%= @name %>
    </div>
    """
  end

  attr :click, :string, required: true
  attr :id, :string, required: true

  def add_product_button(assigns) do
    ~H"""
    <button
      id={"add-#{@id}"}
      title="Add To Cart"
      phx-click={@click}
      phx-value-id={@id}
      class="rounded-md border border-transparent bg-slate-200 px-8 py-2 text-sm font-medium text-slate-900 hover:bg-slate-300"
    >
      Add
    </button>
    """
  end

  def backdrop(assigns) do
    ~H"""
    <div id="backdrop" class="fixed inset-0 bg-slate-500 bg-opacity-75" />
    """
  end

  slot :inner_block, required: true

  def cart(assigns) do
    ~H"""
    <div id="cart" class="fixed inset-y-0 right-0 z-20 w-80 bg-white p-8">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def cart_header(assigns) do
    ~H"""
    <div class="flex h-7 items-center justify-around">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :title, :string, required: true

  def cart_title(assigns) do
    ~H"""
    <h2 class="mb-0 text-xl font-medium text-slate-900">
      <%= @title %>
    </h2>
    """
  end

  attr :click, :string, required: true
  slot :inner_block, required: true

  def hide_cart_button(assigns) do
    ~H"""
    <button
      id="hide-cart-button"
      title="Hide Cart"
      phx-click={@click}
      class="rounded-md bg-white text-slate-400 outline-none hocus:text-slate-500 hocus:ring-2 hocus:ring-slate-500 hocus:ring-offset-2"
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  slot :inner_block, required: true

  def cart_items(assigns) do
    ~H"""
    <ul class="h-[calc(100vh-theme('spacing.7'))] divide-y divide-slate-200 overflow-y-auto px-4 pb-6">
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  attr :product, :string, required: true
  attr :quantity, :integer, required: true

  def cart_item(assigns) do
    ~H"""
    <li class="flex items-center justify-between py-3">
      <span class="p-4 text-3xl">
        <%= @product %>
      </span>
      <span class="text-xl font-medium text-slate-600">
        &times; <%= @quantity %>
      </span>
    </li>
    """
  end
end
