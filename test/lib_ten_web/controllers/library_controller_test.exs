defmodule LibTenWeb.LibraryControllerTest do
  use LibTenWeb.ConnCase

  setup %{conn: conn} do
    {:ok, user} = LibTen.Accounts.Users.create(%{
      email: "user@user.com",
      name: "Test"
    })
    signed_in_conn = sign_in(conn, user)
    {:ok, %{conn: signed_in_conn}}
  end

  test "GET /library", %{conn: conn} do
    conn = get conn, "/library"
    assert html_response(conn, 200)
  end
end
