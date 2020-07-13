defmodule Bolon.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def up do
    create table(:prices) do
      add :item, :string, null: false
      add :type, :string, null: false
      add :price, :integer, null: false
      add :display_order, :integer, null: false
      timestamps()
    end
  end
end
