defmodule Bolon.Price do
  use Ecto.Schema

  schema "prices" do
    field :item, :string
    field :type, :string
    field :price, :integer
    field :display_order, :integer
    timestamps()
  end
end