defmodule LibTenWeb.UserControllerTest do
  use LibTenWeb.ConnCase

  import LibTen.Factory

  alias LibTen.Accounts.Users

  @update_attrs %{name: "Ruslan 2", email: "ruslan-2@10clouds.com"}
  @invalid_attrs %{name: nil, email: nil}

  setup %{conn: conn} do
    user = insert(:user, is_admin: true)
    {:ok, %{
      conn: sign_in(conn, user),
      current_user: user
    }}
  end


  describe "index" do
    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 404) =~ "not found"
    end

    test "lists all users only for admins", %{conn: conn} do
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end


  describe "edit user" do
    setup [:create_user]

    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user, user: user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = get conn, admin_user_path(conn, :edit, user)
      assert html_response(conn, 404) =~ "not found"
    end

    test "renders form for editing chosen user only for admins",
      %{conn: conn, user: user}
    do
      conn = get conn, admin_user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end


  describe "update user" do
    setup [:create_user]

    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user, user: user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = put conn, admin_user_path(conn, :update, user)
      assert html_response(conn, 404) =~ "not found"
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, admin_user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == admin_user_path(conn, :index)
      updated_user = Users.get!(user.id)
      assert updated_user.name == @update_attrs.name
      assert updated_user.email == @update_attrs.email
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, admin_user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end


  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end
end
