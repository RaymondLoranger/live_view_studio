defmodule LiveView.StudioWeb.ShopLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import ShopComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       # [%{image: "🪀", name: "Yoyo"}, %{image: "👟", name: "Sneaks"},...]
       products: Products.list_products(),
       # e.g. %{"🪀" => 1, "👟" => 2 }
       cart: %{}
       # show_cart: false
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.shop id="shop" header="🛒 Mike's Garage Sale 🛒">
      <.focus_wrap id="shop-focus-wrap">
        <.cart_summary>
          <.show_cart_button
            :if={Enum.count(@cart) > 0}
            id="show-cart-button"
            click={toggle_cart()}
            mounted={shake_cart()}
          >
            <.icon name="hero-shopping-cart" />
            <.cart_count count={Enum.count(@cart)} />
          </.show_cart_button>
        </.cart_summary>

        <.products>
          <.product :for={product <- @products}>
            <.product_image image={product.image} />
            <.product_name name={product.name} />
            <.add_product_button click={add_to_and_shake_cart(product)} />
          </.product>
        </.products>

        <.backdrop id="backdrop" click={toggle_cart()} />

        <.cart id="cart">
          <.cart_header>
            <.cart_title title="Shopping Cart" />
            <.hide_cart_button id="hide-cart-button" click={toggle_cart()}>
              <.icon name="hero-x-mark" />
            </.hide_cart_button>
          </.cart_header>

          <.cart_items>
            <.cart_item
              :for={{image, quantity} <- @cart}
              image={image}
              quantity={quantity}
            />
          </.cart_items>
        </.cart>
      </.focus_wrap>
    </.shop>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  # def handle_event("toggle-show-cart", _, socket) do
  #   socket = update(socket, :show_cart, &(!&1))
  #   {:noreply, socket}
  # end

  def handle_event("add-product", %{"id" => id}, socket) do
    cart = Map.update(socket.assigns.cart, id, 1, &(&1 + 1))
    {:noreply, assign(socket, :cart, cart)}
  end

  # Private functions

  @dialyzer {:nowarn_function, toggle_cart: 0}
  @spec toggle_cart :: JS.t()
  defp toggle_cart do
    JS.toggle(
      to: "#cart",
      in: {"ease-in-out duration-300", "translate-x-full", "translate-x-0"},
      out: {"ease-in-out duration-300", "translate-x-0", "translate-x-full"},
      time: 300
    )
    |> JS.toggle(to: "#backdrop", in: "fade-in-scale", out: "fade-out-scale")
  end

  @dialyzer {:nowarn_function, add_to_and_shake_cart: 1}
  @spec add_to_and_shake_cart(map) :: JS.t()
  defp add_to_and_shake_cart(product) do
    JS.push("add-product", value: %{id: product.image}) |> shake_cart()
  end

  @dialyzer {:nowarn_function, shake_cart: 1}
  @spec shake_cart(JS.t()) :: JS.t()
  defp shake_cart(js \\ %JS{}) do
    JS.transition(js, "shake", to: "#show-cart-button", time: 500)
  end
end
