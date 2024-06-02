defmodule LiveView.Studio.Routes do
  alias LiveView.Studio.Flights

  @spec number_starting_with(String.t()) :: [Flights.route()]
  def number_starting_with(_prefix = ""), do: Flights.routes()

  def number_starting_with(prefix) do
    Enum.filter(Flights.routes(), &number_starting_with?(&1, prefix))
  end

  ## Private functions

  @spec number_starting_with?(Flights.route(), String.t()) :: boolean
  defp number_starting_with?({number, _origin, _destination}, prefix) do
    String.starts_with?(number, prefix)
  end
end
