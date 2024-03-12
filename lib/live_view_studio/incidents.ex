defmodule LiveView.Studio.Incidents do
  @moduledoc """
  The Incidents context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LiveView.Studio.Repo

  alias LiveView.Studio.{Geo, PubSub}
  alias LiveView.Studio.Incidents.Incident

  @topic inspect(__MODULE__)
  @descriptions [
    "🦊 Fox in the henhouse",
    "🏢 Stuck in an elevator",
    "🚦 Traffic lights out",
    "🏎 Reckless driving",
    "🐻 Bear in the trash",
    "🤡 Disturbing the peace",
    "🔥 BBQ fire",
    "🙀 #{Faker.Cat.name()} stuck in a tree",
    "🐶 #{Faker.Dog.PtBr.name()} on the loose"
  ]

  @spec subscribe :: :ok | {:error, term}
  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, @topic)
  end

  @doc """
  Returns the list of incidents.

  ## Examples

      iex> list_incidents()
      [%Incident{}, ...]

  """
  @spec list_incidents :: [%Incident{}]
  def list_incidents do
    Repo.all(Incident)
  end

  @spec list_incidents_by_desc_id :: [%Incident{}]
  def list_incidents_by_desc_id do
    Repo.all(from i in Incident, order_by: [desc: i.id])
  end

  @doc """
  Gets a single incident.

  Raises `Ecto.NoResultsError` if the Incident does not exist.

  ## Examples

      iex> get_incident!(123)
      %Incident{}

      iex> get_incident!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_incident!(integer | binary) :: %Incident{}
  def get_incident!(id), do: Repo.get!(Incident, id)

  @doc """
  Creates an incident.

  ## Examples

      iex> create_incident(%{field: value})
      {:ok, %Incident{}}

      iex> create_incident(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_incident(map) :: {:ok, %Incident{}} | {:error, %Changeset{}}
  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:incident_created)
  end

  @doc """
  Creates a random incident.

  ## Examples

      iex> create_random_incident()
      {:ok, %Incident{}}

  """
  @spec create_random_incident :: {:ok, %Incident{}}
  def create_random_incident do
    # {lat, lng} = Geo.randomDenverLatLng()
    {lat, lng} = Geo.randomMontrealLatLng()

    {:ok, _incident} =
      create_incident(%{
        lat: lat,
        lng: lng,
        description: Enum.random(@descriptions)
      })
  end

  @doc """
  Updates an incident.

  ## Examples

      iex> update_incident(incident, %{field: new_value})
      {:ok, %Incident{}}

      iex> update_incident(incident, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_incident(%Incident{}, map) ::
          {:ok, %Incident{}} | {:error, %Changeset{}}
  def update_incident(%Incident{} = incident, attrs) do
    incident
    |> Incident.changeset(attrs)
    |> Repo.update()
    |> broadcast(:incident_updated)
  end

  @doc """
  Deletes an incident.

  ## Examples

      iex> delete_incident(incident)
      {:ok, %Incident{}}

      iex> delete_incident(incident)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_incident(%Incident{}) ::
          {:ok, %Incident{}} | {:error, %Changeset{}}
  def delete_incident(%Incident{} = incident) do
    Repo.delete(incident)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incident changes.

  ## Examples

      iex> change_incident(incident)
      %Ecto.Changeset{data: %Incident{}}

  """
  @spec change_incident(%Incident{}, map) :: %Changeset{}
  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end

  ## Private functions

  @spec broadcast({:ok, %Incident{}} | {:error, %Changeset{}}, atom) ::
          {:ok, %Incident{}} | {:error, %Changeset{}}
  defp broadcast({:ok, incident}, event) do
    Phoenix.PubSub.broadcast(PubSub, @topic, {__MODULE__, event, incident})
    {:ok, incident}
  end

  defp broadcast({:error, _changeset} = error, _event), do: error
end
