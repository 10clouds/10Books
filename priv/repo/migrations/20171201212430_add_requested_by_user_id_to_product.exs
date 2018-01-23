defmodule LibTen.Repo.Migrations.AddRequestedByUserIdToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :requested_by_user_id, references(:users)
    end
  end
end
