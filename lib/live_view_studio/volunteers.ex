defmodule LiveView.Studio.Volunteers do
  @moduledoc """
  The Volunteers context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LiveView.Studio.Repo

  alias LiveView.Studio.PubSub
  alias LiveView.Studio.Volunteers.Volunteer

  @topic inspect(__MODULE__)
  # => "LiveView.Studio.Volunteers"

  @spec subscribe :: :ok | {:error, term}
  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, @topic)
  end

  @doc """
  Returns the list of volunteers.

  ## Examples

      iex> list_volunteers()
      [%Volunteer{}, ...]

  """
  @spec list_volunteers :: [%Volunteer{}]
  def list_volunteers do
    Repo.all(Volunteer)
  end

  @spec list_volunteers_by_desc_id :: [%Volunteer{}]
  def list_volunteers_by_desc_id do
    Repo.all(from v in Volunteer, order_by: [desc: v.id])
  end

  @doc """
  Gets a single volunteer.

  Raises `Ecto.NoResultsError` if the Volunteer does not exist.

  ## Examples

      iex> get_volunteer!(123)
      %Volunteer{}

      iex> get_volunteer!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_volunteer!(integer | binary) :: %Volunteer{}
  def get_volunteer!(id), do: Repo.get!(Volunteer, id)

  @doc """
  Creates a volunteer.

  ## Examples

      iex> create_volunteer(%{field: value})
      {:ok, %Volunteer{}}

      iex> create_volunteer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_volunteer(map) :: {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def create_volunteer(attrs \\ %{}) do
    %Volunteer{}
    |> Volunteer.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:volunteer_created)
  end

  @doc """
  Updates a volunteer.

  ## Examples

      iex> update_volunteer(volunteer, %{field: new_value})
      {:ok, %Volunteer{}}

      iex> update_volunteer(volunteer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_volunteer(%Volunteer{}, map) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def update_volunteer(%Volunteer{} = volunteer, attrs) do
    volunteer
    |> Volunteer.changeset(attrs)
    |> Repo.update()
    |> broadcast(:volunteer_updated)
  end

  @spec toggle_status_volunteer(%Volunteer{}) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def toggle_status_volunteer(%Volunteer{} = volunteer) do
    update_volunteer(volunteer, %{checked_out: !volunteer.checked_out})
  end

  @spec toggle_status_volunteer(integer | binary) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def toggle_status_volunteer(id) do
    id |> get_volunteer!() |> toggle_status_volunteer()
  end

  @doc """
  Deletes a volunteer.

  ## Examples

      iex> delete_volunteer(volunteer)
      {:ok, %Volunteer{}}

      iex> delete_volunteer(volunteer)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_volunteer(%Volunteer{}) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def delete_volunteer(%Volunteer{} = volunteer) do
    Repo.delete(volunteer) |> broadcast(:volunteer_deleted)
  end

  @spec delete_volunteer(integer | binary) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  def delete_volunteer(id) do
    id |> get_volunteer!() |> delete_volunteer()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking volunteer changes.

  ## Examples

      iex> change_volunteer(volunteer)
      %Ecto.Changeset{data: %Volunteer{}}

  """
  @spec change_volunteer(%Volunteer{}, map) :: %Changeset{}
  def change_volunteer(%Volunteer{} = volunteer, attrs \\ %{}) do
    Volunteer.changeset(volunteer, attrs)
  end

  @spec validate(%Volunteer{}, map) :: %Changeset{}
  def validate(%Volunteer{} = volunteer, attrs) do
    volunteer
    |> change_volunteer(attrs)
    # Required to see validation errors...
    |> struct(action: :validate)
  end

  ## Private functions

  @spec broadcast({:ok, %Volunteer{}} | {:error, %Changeset{}}, atom) ::
          {:ok, %Volunteer{}} | {:error, %Changeset{}}
  defp broadcast({:ok, volunteer}, event) do
    Phoenix.PubSub.broadcast(PubSub, @topic, {event, volunteer})
    {:ok, volunteer}
  end

  defp broadcast({:error, _changeset} = error, _event), do: error
end
