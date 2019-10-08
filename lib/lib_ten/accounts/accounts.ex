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

  def get_by(attrs), do: Repo.get_by(User, attrs)

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
      user =
        Repo.get_by(User, %{google_uid: attrs.google_uid}) ||
          find_and_update_legacy_google_user(attrs)

      if user do
        user
        |> Changeset.cast(attrs, [:email, :name, :avatar_url])
        |> Repo.update()
      else
        create_user(attrs)
      end
    else
      msg =
        "Only accounts with #{Enum.join(allowed_domains, ", ")} domain" <>
          if(length(allowed_domains) > 1, do: "s", else: "") <> " allowed"

      {:error, msg}
    end
  end

  # NOTE:
  # We used to identify users by email for google auth
  defp find_and_update_legacy_google_user(%{email: email, google_uid: google_uid}) do
    user =
      from(u in User, where: u.email == ^email and is_nil(u.google_uid))
      |> Repo.one()

    if user do
      {:ok, updated_user} =
        user
        |> User.changeset(%{google_uid: google_uid})
        |> Repo.update()

      updated_user
    else
      nil
    end
  end
end
