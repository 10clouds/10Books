defmodule LibTen.Repo.Migrations.CreateProductUses do
  use Ecto.Migration

  def change do
    create table(:product_uses) do
      add :ended_at, :naive_datetime
      add :user_id, references(:users), null: false
      add :product_id, references(:products), null: false

      timestamps()
    end

    create unique_index(:product_uses, [:product_id, :ended_at], where: "ended_at IS NOT NULL")
    create unique_index(:product_uses, [:product_id], where: "ended_at IS NULL")
  end
end
