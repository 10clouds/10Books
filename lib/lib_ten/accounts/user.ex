defmodule LibTen.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibTen.Accounts.User

  schema "users" do
    field :email, :string
    field :name, :string
    field :avatar_url, :string
    field :is_admin, :boolean, default: false
    field :google_uid, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :avatar_url, :email, :is_admin, :google_uid])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
