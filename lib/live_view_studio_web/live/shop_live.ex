defmodule LiveView.StudioWeb.ShopLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import ShopComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       products: Products.list_products(),
       cart: %{},
       show_cart: false
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.shop id="shop" header="🛒 Mike's Garage Sale 🛒">
      <.cart_summary>
        <.show_cart_button :if={Enum.count(@cart) > 0}>
          <.icon name="hero-shopping-cart" />
          <.cart_count count={Enum.count(@cart)} />
        </.show_cart_button>
      </.cart_summary>

      <.products>
        <.product :for={product <- @products}>
          <.product_image image={product.image} />
          <.product_name name={product.name} />
          <.add_product_button click="add-product" id={product.image} />
        </.product>
      </.products>

      <.backdrop :if={@show_cart} />

      <.cart :if={@show_cart}>
        <.cart_header>
          <.cart_title title="Shopping Cart" />
          <.hide_cart_button>
            <.icon name="hero-x-mark" />
          </.hide_cart_button>
        </.cart_header>
        
        <.cart_items>
          <.cart_item
            :for={{product, quantity} <- @cart}
            product={product}
            quantity={quantity}
          />
        </.cart_items>
      </.cart>
    </.shop>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("toggle-show-cart", _, socket) do
    socket = update(socket, :show_cart, fn show -> !show end)
    {:noreply, socket}
  end

  def handle_event("add-product", %{"id" => id}, socket) do
    cart = Map.update(socket.assigns.cart, id, 1, &(&1 + 1))
    {:noreply, assign(socket, :cart, cart)}
  end
end
