defmodule LibTen.Repo.Migrations.AddColorsToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :text_color, :string, null: false
      add :background_color, :string, null: false
    end
  end
end
