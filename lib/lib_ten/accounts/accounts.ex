defmodule LibTen.Accounts do
  import Ecto.Query, warn: false
  alias LibTen.Repo
  alias LibTen.Accounts.User

  def get_by!(attrs \\ %{}) do
    User
    |> Repo.get_by!(attrs)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
