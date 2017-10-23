defmodule LibTenWeb.Admin.UserController do
  use LibTenWeb, :controller

  alias LibTen.Accounts.Users

  def index(conn, _params) do
    users = Users.list()
    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get!(id)
    changeset = Users.change(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get!(id)

    case Users.update(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
