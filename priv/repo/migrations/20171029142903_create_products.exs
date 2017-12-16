defmodule LibTen.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :text
      add :url, :text
      add :author, :text
      add :status, :string
      add :deleted, :boolean, null: false

      timestamps()
    end

    create index(:products, ["inserted_at DESC NULLS LAST"])
  end
end
