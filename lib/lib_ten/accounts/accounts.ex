defmodule LibTen.Accounts do
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LibTen.Repo
  alias LibTen.Accounts.User

  def list_users(ids) do
    User
    |> where([q], q.id in ^ids)
    |> Repo.all()
  end

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
    allowed_domains =
      Application.fetch_env!(:lib_ten, :allowed_google_auth_domains)
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn str -> "@" <> str end)

    if String.ends_with?(attrs.email, allowed_domains) do
      user = Repo.get_by(User, %{email: attrs.email})

      if user do
        user
        |> Changeset.cast(attrs, [:name, :avatar_url])
        |> Repo.update()
      else
        create_user(attrs)
      end
    else
      msg =
        "Only accounts with #{Enum.join(allowed_domains, ", ")} domain" <>
          (if length(allowed_domains) > 1, do: "s", else: "") <> " allowed"

      {:error, msg}
    end
  end
end
