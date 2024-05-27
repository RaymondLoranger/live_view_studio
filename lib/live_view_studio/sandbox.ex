defmodule LiveView.Studio.Sandbox do
  @spec calculate_weight(binary, binary, binary) :: float
  def calculate_weight(length, width, depth)
      when is_binary(length) and is_binary(width) and is_binary(depth) do
    weight = to_float(length) * to_float(width) * to_float(depth) * 7.3
    Float.round(weight, 1)
  end

  @spec calculate_price(float) :: float
  def calculate_price(weight) when is_float(weight) do
    weight * 0.15
  end

  @spec calculate_fee(binary) :: float
  def calculate_fee(zip) when is_binary(zip) do
    to_integer(zip) |> Integer.digits() |> Enum.sum() |> :erlang.float()
  end

  ## Private functions

  # Integer.parse("34") => {34, ""}
  # Integer.parse("34.5") => {34, ".5"}
  # Integer.parse("34bad") => {34, "bad"}
  @spec to_integer(binary) :: integer
  defp to_integer(binary) do
    case Integer.parse(binary) do
      {integer, _remainder_of_binary} -> integer
      :error -> 0
    end
  end

  # Float.parse("34") => {34.0, ""}
  # Float.parse("34.25") => {34.25, ""}
  # Float.parse("56.5bad") => {56.5, "bad"}
  # Float.parse("1.79e+3") => {1790.0, ""}
  @spec to_float(binary) :: float
  defp to_float(binary) do
    case Float.parse(binary) do
      {float, _remainder_of_binary} -> float
      :error -> 0.0
    end
  end
end
