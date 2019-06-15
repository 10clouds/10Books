defmodule LibTen.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :logo, :string

      timestamps()
    end

  end
end
