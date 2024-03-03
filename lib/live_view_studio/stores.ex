defmodule LiveView.Studio.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias LiveView.Studio.Repo

  alias LiveView.Studio.Stores.Store

  @typedoc "Store"
  @type store :: %Store{}
  @typedoc "Zip code"
  @type zip :: String.t()
  @typedoc "City"
  @type city :: String.t()
  @typedoc "Zip or City"
  @type zip_or_city :: zip | city

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    Repo.all(Store)
  end

  @spec search_by_zip(zip) :: [store]
  def search_by_zip(zip) do
    # Pretend search takes a while...
    :timer.sleep(1000)

    from(s in Store, where: s.zip == ^zip)
    |> Repo.all()
  end

  @spec search_by_city(city) :: [store]
  def search_by_city(city) do
    # Pretend search takes a while...
    :timer.sleep(1000)

    from(s in Store, where: s.city == ^city)
    |> Repo.all()
  end

  @spec areas :: [{zip, city}]
  def areas do
    for store <- list_stores(), uniq: true do
      {store.zip, store.city}
    end
    |> Enum.sort()
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id), do: Repo.get!(Store, id)

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{data: %Store{}}

  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end
end
