defmodule LibTen.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibTen.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :is_admin, :boolean

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :is_admin])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
