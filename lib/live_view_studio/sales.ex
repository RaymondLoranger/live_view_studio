defmodule LiveView.Studio.Sales do
  @spec new_orders :: pos_integer
  def new_orders, do: Enum.random(5..1000)

  @spec sales_amount :: pos_integer
  def sales_amount, do: Enum.random(10..1000)

  @spec satisfaction :: pos_integer
  def satisfaction, do: Enum.random(1..100)
end
