defmodule LiveView.Studio.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boats" do
    field :model, :string
    field :price, :string
    field :type, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, [:model, :price, :type, :image])
    |> validate_required([:model, :price, :type, :image])
  end
end
