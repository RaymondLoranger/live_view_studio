defmodule LiveView.Studio.Flights.Flight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flights" do
    field :number, :string
    field :origin, :string
    field :destination, :string
    field :departure_time, :utc_datetime_usec
    field :arrival_time, :utc_datetime_usec

    timestamps()
  end

  @doc false
  def changeset(flight, attrs) do
    flight
    |> cast(attrs, [
      :number,
      :origin,
      :destination,
      :departure_time,
      :arrival_time
    ])
    |> validate_required([
      :number,
      :origin,
      :destination,
      :departure_time,
      :arrival_time
    ])
  end
end
