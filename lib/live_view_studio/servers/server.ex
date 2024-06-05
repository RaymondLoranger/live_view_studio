defmodule LiveView.Studio.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @min_length "should be at least %{count} characters"
  @max_length "should be at most %{count} characters"

  schema "servers" do
    field :name, :string
    field :status, :string, default: "down"
    field :deploy_count, :integer, default: 0
    field :size, :float
    field :framework, :string
    field :git_repo, :string
    field :last_commit_id, :string, default: ""
    field :last_commit_message, :string, default: ""
    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    # We've removed :deploy_count, :last_commit_id, and :last_commit_message
    # from cast since we don't assign them via the input form...
    |> cast(attrs, [:name, :framework, :size, :git_repo, :status])
    |> validate_required([:name, :framework, :size, :git_repo])
    # :name
    |> validate_length(:name, min: 2, message: @min_length)
    |> validate_length(:name, max: 30, message: @max_length)
    # :framework
    |> validate_length(:framework, min: 2, message: @min_length)
    |> validate_length(:framework, max: 30, message: @max_length)
    # :size
    |> validate_number(:size, greater_than: 0, less_than: 90)
    # :git_repo
    |> validate_length(:git_repo, min: 2, message: @min_length)
    |> validate_length(:git_repo, max: 30, message: @max_length)
    # :status
    |> validate_inclusion(:status, ["up", "down"])
  end
end
