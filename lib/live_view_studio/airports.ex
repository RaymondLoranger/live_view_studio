defmodule LiveView.Studio.Airports do
  alias LiveView.Studio.Flights

  @spec prefixed(String.t()) :: [Flights.airport()]
  def prefixed(_prefix = ""), do: airports()

  def prefixed(prefix) do
    Enum.filter(airports(), &has_prefix?(&1, prefix))
  end

  ## Private functions

  @spec has_prefix?(Flights.airport(), String.t()) :: boolean
  defp has_prefix?({code, _city}, prefix) do
    String.starts_with?(code, String.upcase(prefix))
  end

  @spec airports :: [Flights.airport()]
  defp airports do
    [
      {"ATL", "Atlanta, GA"},
      {"BOS", "Boston, MA"},
      {"BWI", "Baltimore, MD"},
      {"CLT", "Charlotte, NC"},
      {"DAB", "Daytona Beach, FL"},
      {"DCA", "Arlington, VA"},
      {"DEN", "Denver, CO"},
      {"DFW", "Dallas Fort Worth, TX"},
      {"DTW", "Detroit, MI"},
      {"EWR", "Newark, NJ"},
      {"FLL", "Fort Lauderdale, FL"},
      {"HNL", "Honolulu, HI"},
      {"IAD", "Dulles, VA"},
      {"IAH", "Houston, TX"},
      {"JFK", "New York, NY"},
      {"LAS", "Las Vegas, NV"},
      {"LAX", "Los Angeles, CA"},
      {"LGA", "LaGuardia, NY"},
      {"MCO", "Orlando, FL"},
      {"MDW", "Chicago, IL"},
      {"MIA", "Miami, FL"},
      {"MSP", "Minneapolis, MN"},
      {"ORD", "Chicago, IL"},
      {"PDX", "Portland, OR"},
      {"PHL", "Philadelphia, PA"},
      {"PHX", "Phoenix, AZ"},
      {"SAN", "San Diego, CA"},
      {"SEA", "Seattle, WA"},
      {"SFO", "San Francisco, CA"},
      {"SLC", "Salt Lake City, UT"},
      {"TPA", "Tampa, FL"},
      {"YUL", "Montréal, QC"}
    ]
  end
end
