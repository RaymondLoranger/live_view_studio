defmodule LiveView.Studio.Servers do
  @moduledoc """
  The Servers context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LiveView.Studio.Repo

  alias LiveView.Studio.PubSub
  alias LiveView.Studio.Servers.Server

  @topic inspect(__MODULE__)
  # => "LiveView.Studio.Servers"

  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, @topic)
  end

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers()
      [%Server{}, ...]

  """
  @spec list_servers :: [%Server{}]
  def list_servers do
    Repo.all(Server)
  end

  @spec list_servers_by_desc_id :: [%Server{}]
  def list_servers_by_desc_id do
    Repo.all(from s in Server, order_by: [desc: s.id])
  end

  @spec list_servers_by_asc_name :: [%Server{}]
  def list_servers_by_asc_name do
    Repo.all(from s in Server, order_by: [asc: s.name])
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(123)
      %Server{}

      iex> get_server!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_server!(integer | binary) :: %Server{}
  def get_server!(id), do: Repo.get!(Server, id)

  @spec get_server_by_name(binary) :: %Server{} | nil
  def get_server_by_name(name), do: Repo.get_by(Server, name: name)

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(%{field: value})
      {:ok, %Server{}}

      iex> create_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_server(map) :: {:ok, %Server{}} | {:error, %Changeset{}}
  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:server_created)
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_server(%Server{}, map) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
    |> broadcast(:server_updated)
  end

  @spec toggle_status_server(%Server{}) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  def toggle_status_server(%Server{status: "up"} = server) do
    update_server(server, %{status: "down"})
  end

  def toggle_status_server(%Server{status: "down"} = server) do
    update_server(server, %{status: "up"})
  end

  @spec toggle_status_server!(integer | binary) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  def toggle_status_server!(id) do
    id |> get_server!() |> toggle_status_server()
  end

  @doc """
  Deletes a server.

  ## Examples

      iex> delete_server(server)
      {:ok, %Server{}}

      iex> delete_server(server)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_server(%Server{}) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  def delete_server(%Server{} = server) do
    Repo.delete(server) |> broadcast(:server_deleted)
  end

  @spec delete_server!(integer | binary) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  def delete_server!(id) do
    id |> get_server!() |> delete_server()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(server)
      %Ecto.Changeset{data: %Server{}}

  """
  @spec change_server(%Server{}, map) :: %Changeset{}
  def change_server(%Server{} = server, attrs \\ %{}) do
    Server.changeset(server, attrs)
  end

  @spec validate(%Server{}, map) :: %Changeset{}
  def validate(%Server{} = server, attrs) do
    change_server(server, attrs)
    # Required to see validation errors...
    |> struct(action: :validate)
  end

  ## Private functions

  @spec broadcast({:ok, %Server{}} | {:error, %Changeset{}}, atom) ::
          {:ok, %Server{}} | {:error, %Changeset{}}
  defp broadcast({:ok, server}, event) do
    Phoenix.PubSub.broadcast(PubSub, @topic, {event, server})
    {:ok, server}
  end

  defp broadcast({:error, _changeset} = error, _event), do: error
end
