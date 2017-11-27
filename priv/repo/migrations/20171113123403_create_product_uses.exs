defmodule LibTen.Repo.Migrations.CreateProductUses do
  use Ecto.Migration

  def change do
    create table(:product_uses) do
      add :ended_at, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:product_uses, [:product_id, :ended_at], where: "ended_at IS NOT NULL")
    create unique_index(:product_uses, [:product_id], where: "ended_at IS NULL")
  end
end
