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

  def find_or_create_user(attrs \\ %{}) do
    if String.ends_with?(attrs.email, "@10clouds.com") do
      user = Repo.get_by(User, %{email: attrs.email})
      if user do
        {:ok, user}
      else
        create_user(attrs)
      end
    else
      {:error, :invalid_email_domain}
    end
  end
end
