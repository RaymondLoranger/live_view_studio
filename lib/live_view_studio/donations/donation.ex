defmodule LiveView.Studio.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :emoji, :string
    field :item, :string
    field :quantity, :integer
    field :days_until_expires, :integer

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:emoji, :item, :quantity, :days_until_expires])
    |> validate_required([:emoji, :item, :quantity, :days_until_expires])
  end
end
