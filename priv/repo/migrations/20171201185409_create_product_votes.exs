defmodule LibTen.Repo.Migrations.CreateProductVotes do
  use Ecto.Migration

  def change do
    create table(:product_votes) do
      add :product_id, references(:products), null: false
      add :user_id, references(:users), null: false
      add :is_upvote, :boolean, null: false

      timestamps()
    end

    create unique_index(:product_votes, [:product_id, :user_id])
  end
end
