defmodule LiveView.Studio.Flights do
  @moduledoc """
  The Flights context.
  """

  import Ecto.Query, warn: false
  alias LiveView.Studio.Repo

  alias LiveView.Studio.Flights.Flight

  @typedoc "Flight"
  @type flight :: %Flight{}
  @typedoc ~s'Flight number e.g. "450"'
  @type flight_number :: String.t()
  @typedoc ~s'Airport code e.g. "DEN"'
  @type airport_code :: String.t()
  @typedoc ~s'Airport city e.g. "Denver International Airport"'
  @type airport_city :: String.t()
  @typedoc ~s'Airport e.g. {"DEN", "Denver International Airport"}'
  @type airport :: {airport_code, airport_city}
  @typedoc "Flight origin"
  @type origin :: airport_code
  @typedoc "Flight destination"
  @type destination :: airport_code
  @typedoc ~s'Flight route e.g. {"450", "DEN", "ORD"}'
  @type route :: {flight_number, origin, destination}
  @typedoc "Flight number or airport code"
  @type flight_number_or_airport_code :: flight_number | airport_code

  @doc """
  Returns the list of flights.

  ## Examples

      iex> list_flights()
      [%Flight{}, ...]

  """
  def list_flights do
    Repo.all(Flight)
  end

  @spec search_by_flight_number(flight_number) :: [flight]
  def search_by_flight_number(number) do
    # Pretend search takes a while...
    :timer.sleep(1000)

    from(f in Flight, where: f.number == ^number)
    |> Repo.all()
  end

  @spec search_by_airport_code(origin | destination) :: [flight]
  def search_by_airport_code(code) do
    # Pretend search takes a while...
    :timer.sleep(1000)

    from(f in Flight, where: ^String.upcase(code) in [f.origin, f.destination])
    |> Repo.all()
  end

  @spec routes :: [route]
  def routes do
    for flight <- list_flights(), uniq: true do
      {flight.number, flight.origin, flight.destination}
    end
    |> Enum.sort()
  end

  @doc """
  Gets a single flight.

  Raises `Ecto.NoResultsError` if the Flight does not exist.

  ## Examples

      iex> get_flight!(123)
      %Flight{}

      iex> get_flight!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flight!(id), do: Repo.get!(Flight, id)

  @doc """
  Creates a flight.

  ## Examples

      iex> create_flight(%{field: value})
      {:ok, %Flight{}}

      iex> create_flight(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flight(attrs \\ %{}) do
    %Flight{}
    |> Flight.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flight.

  ## Examples

      iex> update_flight(flight, %{field: new_value})
      {:ok, %Flight{}}

      iex> update_flight(flight, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flight(%Flight{} = flight, attrs) do
    flight
    |> Flight.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flight.

  ## Examples

      iex> delete_flight(flight)
      {:ok, %Flight{}}

      iex> delete_flight(flight)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flight(%Flight{} = flight) do
    Repo.delete(flight)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flight changes.

  ## Examples

      iex> change_flight(flight)
      %Ecto.Changeset{data: %Flight{}}

  """
  def change_flight(%Flight{} = flight, attrs \\ %{}) do
    Flight.changeset(flight, attrs)
  end
end
