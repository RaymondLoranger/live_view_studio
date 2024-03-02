defmodule LiveView.Studio.Sandbox do
  @type dim :: binary | number
  @type fee :: binary | number

  @spec calculate_weight(dim, dim, dim) :: float
  def calculate_weight(length, width, depth)
      when is_binary(length) and is_binary(width) and is_binary(depth) do
    calculate_weight(to_float(length), to_float(width), to_float(depth))
  end

  def calculate_weight(length, width, depth)
      when is_number(length) and is_number(width) and is_number(depth) do
    Float.round(length * width * depth * 7.3, 1)
  end

  @spec calculate_price(float) :: float
  def calculate_price(weight) when is_float(weight) do
    Float.round(weight * 0.15, 2)
  end

  @spec calculate_fee(fee) :: float
  def calculate_fee(zip) when is_binary(zip) do
    to_integer(zip) |> Integer.digits() |> Enum.sum() |> calculate_fee()
  end

  def calculate_fee(fee) when is_number(fee) do
    Float.round(fee / 1, 2)
  end

  ## Private functions

  # Integer.parse("34") => {34, ""}
  # Integer.parse("34.5") => {34, ".5"}
  @spec to_integer(binary) :: integer
  defp to_integer(binary) do
    case Integer.parse(binary) do
      {integer, _remainder_of_binary} -> integer
      :error -> 0
    end
  end

  # Float.parse("34") => {34.0, ""}
  # Float.parse("34.25") => {34.25, ""}
  # Float.parse("56.5xyz") => {56.5, "xyz"}
  # Float.parse("1.79e+3") => {1790.0, ""}
  @spec to_float(binary) :: float
  defp to_float(binary) do
    case Float.parse(binary) do
      {float, _remainder_of_binary} -> float
      :error -> 0.0
    end
  end
end
