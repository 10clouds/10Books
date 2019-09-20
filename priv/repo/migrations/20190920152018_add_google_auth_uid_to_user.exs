defmodule LibTen.Repo.Migrations.AddGoogleAuthUidToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :google_uid, :string
    end
    unique_index(:users, :google_uid)
  end
end
