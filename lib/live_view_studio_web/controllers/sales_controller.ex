defmodule LiveView.StudioWeb.SalesController do
  use LiveView.StudioWeb, :controller

  def home(conn, _params) do
    # fetch top sellers and recent orders
    assigns = [
      sellers: Enum.random(4..9),
      orders: Enum.random(15..19),
      # skip the default app layout
      layout: false
    ]

    render(conn, :home, assigns)
  end
end
