defmodule LibTen.Repo.Migrations.AddReturnSubscribersToProductUse do
  use Ecto.Migration

  def change do
    alter table(:product_uses) do
      add :return_subscribers, {:array, :integer}, default: []
    end
  end
end
