defmodule LibTenWeb.AuthController do
  use LibTenWeb, :controller
  plug Ueberauth

  alias LibTen.Accounts

  def index(conn, _params) do
    if get_session(conn, :user_id) do
      redirect(conn, to: library_path(conn, :index))
    else
      conn
      |> put_layout("empty.html")
      |> render("index.html")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{email: auth.info.email, name: auth.info.name}
    case Accounts.find_or_create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: library_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def sign_out(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/")
  end
end
