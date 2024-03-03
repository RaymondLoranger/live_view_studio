defmodule LiveView.Studio.Licenses do
  @spec calculate(pos_integer) :: float
  def calculate(seats) when seats <= 5, do: seats * 20.0
  def calculate(seats), do: 100 + (seats - 5) * 15.0
end
