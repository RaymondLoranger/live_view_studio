defmodule LiveView.Studio.Desks do
  @moduledoc """
  The Desks context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LiveView.Studio.Repo

  alias LiveView.Studio.PubSub
  alias LiveView.Studio.Desks.Desk

  @topic inspect(__MODULE__)

  @spec subscribe :: :ok | {:error, term}
  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, @topic)
  end

  @doc """
  Returns the list of desks.

  ## Examples

      iex> list_desks()
      [%Desk{}, ...]

  """
  @spec list_desks :: [%Desk{}]
  def list_desks do
    Repo.all(Desk)
  end

  @spec list_desks_by_desc_id :: [%Desk{}]
  def list_desks_by_desc_id do
    Repo.all(from(d in Desk, order_by: [desc: d.id]))
  end

  @doc """
  Gets a single desk.

  Raises `Ecto.NoResultsError` if the Desk does not exist.

  ## Examples

      iex> get_desk!(123)
      %Desk{}

      iex> get_desk!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_desk!(integer | binary) :: %Desk{}
  def get_desk!(id), do: Repo.get!(Desk, id)

  @doc """
  Creates a desk.

  ## Examples

      iex> create_desk(%{field: value})
      {:ok, %Desk{}}

      iex> create_desk(%{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_desk(map, (%Desk{} -> {:ok, %Desk{}})) ::
          {:ok, %Desk{}} | {:error, %Changeset{}}
  def create_desk(attrs \\ %{}, fun \\ &{:ok, &1}) do
    %Desk{}
    |> Desk.changeset(attrs)
    |> Repo.insert()
    |> after_save(fun)
    |> broadcast(:desk_created)
  end

  @doc """
  Updates a desk.

  ## Examples

      iex> update_desk(desk, %{field: new_value})
      {:ok, %Desk{}}

      iex> update_desk(desk, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_desk(%Desk{}, map, (%Desk{} -> {:ok, %Desk{}})) ::
          {:ok, %Desk{}} | {:error, %Changeset{}}
  def update_desk(%Desk{} = desk, attrs, fun \\ &{:ok, &1}) do
    desk
    |> Desk.changeset(attrs)
    |> Repo.update()
    |> after_save(fun)
    |> broadcast(:desk_updated)
  end

  @doc """
  Deletes a desk.

  ## Examples

      iex> delete_desk(desk)
      {:ok, %Desk{}}

      iex> delete_desk(desk)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_desk(%Desk{}) :: {:ok, %Desk{}} | {:error, %Changeset{}}
  def delete_desk(%Desk{} = desk) do
    Repo.delete(desk)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking desk changes.

  ## Examples

      iex> change_desk(desk)
      %Ecto.Changeset{data: %Desk{}}

  """
  @spec change_desk(%Desk{}, map) :: %Changeset{}
  def change_desk(%Desk{} = desk, attrs \\ %{}) do
    Desk.changeset(desk, attrs)
  end

  @spec validate(%Desk{}, map) :: %Changeset{}
  def validate(%Desk{} = desk, attrs) do
    change_desk(desk, attrs)
    # Required to see validation errors...
    |> struct(action: :validate)
  end

  ## Private functions

  @spec after_save(tuple, fun) :: {:ok, %Desk{}} | {:error, %Changeset{}}
  defp after_save({:ok, desk}, fun), do: {:ok, _desk} = fun.(desk)
  defp after_save({:error, _changeset} = error, _fun), do: error

  @spec broadcast({:ok, %Desk{}} | {:error, %Changeset{}}, atom) ::
          {:ok, %Desk{}} | {:error, %Changeset{}}
  defp broadcast({:ok, desk}, event) do
    Phoenix.PubSub.broadcast(PubSub, @topic, {event, desk})
    {:ok, desk}
  end

  defp broadcast({:error, _changeset} = error, _event), do: error
end
