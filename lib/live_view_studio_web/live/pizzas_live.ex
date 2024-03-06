defmodule LiveView.StudioWeb.PizzasLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import PizzasComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    # Here orders: [] is ok as we have phx-update="append"...
    {:ok,
     assign(socket, page_title: "Pizzas Infinite Scroll", page: 1, per_page: 10)
     |> assign_orders(), temporary_assigns: [orders: []]}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.orders id="orders" header="Pizza Lovers Timeline 🍕" update="append">
      <.order :for={order <- @orders} id={"order-#{order.id}"}>
        <.id order={order} />
        <div>
          <.pizza order={order} />
          <.username order={order} />
        </div>
      </.order>

      <:footer>
        <.footer id="footer" hook="InfiniteScroll" no_more={@no_more} />
      </:footer>
    </.orders>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("load-more", _params, socket) do
    {:noreply, socket |> update(:page, &(&1 + 1)) |> assign_orders()}
  end

  ## Private functions

  @spec assign_orders(Socket.t()) :: Socket.t()
  defp assign_orders(%Socket{assigns: assigns} = socket) do
    orders = PizzaOrders.list_pizza_orders(assigns)
    assign(socket, orders: orders, no_more: Enum.empty?(orders))
  end
end
