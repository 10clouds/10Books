defmodule LibTen.Admin.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :logo, :string
    timestamps()
  end

  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:logo])
  end
end
