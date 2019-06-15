defmodule LibTenWeb.Admin.SettingsControlledTest do
  use LibTenWeb.ConnCase
  import LibTen.Factory
  alias LibTen.Accounts.Users

  setup %{conn: conn} do
    user = insert(:user, is_admin: true)

    {:ok,
     %{
       conn: sign_in(conn, user),
       current_user: user
     }}
  end

  describe "index" do
    test "renders 404 unless admin",
         %{conn: conn, current_user: current_user} do
      Users.update(current_user, %{is_admin: false})
      conn = get(conn, admin_settings_path(conn, :index))
      assert html_response(conn, 404) =~ "not found"
    end

    test "renders form if admin", %{conn: conn} do
      conn = get(conn, admin_settings_path(conn, :index))
      assert html_response(conn, 200) =~ "Update"
    end
  end

  describe "update" do
    test "renders 404 unless admin",
         %{conn: conn, current_user: current_user} do
      Users.update(current_user, %{is_admin: false})
      conn = put(conn, admin_settings_path(conn, :update))
      assert html_response(conn, 404) =~ "not found"
    end

    test "handles valid update", %{conn: conn} do
      conn = put(conn, admin_settings_path(conn, :update, %{settings: %{logo: "test2.png"}}))
      assert redirected_to(conn) == admin_settings_path(conn, :index)

      conn = get(conn, admin_settings_path(conn, :index))
      assert html_response(conn, 200) =~ "test2.png"
    end
  end
end
