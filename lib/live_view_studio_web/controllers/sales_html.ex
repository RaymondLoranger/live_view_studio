defmodule LiveView.StudioWeb.SalesHTML do
  use LiveView.StudioWeb, [:html, :aliases]

  def home(assigns) do
    ~H"""
    <%= live_render(@conn, SalesLive) %>
    <div class="text-center font-extrabold">
      <.header inner_class="text-cool-gray-900 text-4xl mb-8 hover:opacity-70">
        Sales Stuff
      </.header>

      <h2 class="font-bold">Top Sellers</h2>
      <p class="mb-4 font-bold">
        Number of top sellers: <%= @sellers %>
      </p>

      <h2 class="font-bold">Recent Orders</h2>
      <p class="mb-4 font-bold">
        Number of recent orders: <%= @orders %>
      </p>
    </div>
    """
  end
end
