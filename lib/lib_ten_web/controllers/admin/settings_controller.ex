defmodule LibTenWeb.Admin.SettingsController do
  use LibTenWeb, :controller
  alias LibTen.Admin

  def index(conn, _params) do
    changeset = Admin.change_settings(conn.assigns.settings)
    render(conn, "index.html", changeset: changeset)
  end

  def update(conn, %{"settings" => params}) do
    case Admin.update_settings(conn.assigns.settings, params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Settings updated successfully.")
        |> redirect(  to: admin_settings_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
