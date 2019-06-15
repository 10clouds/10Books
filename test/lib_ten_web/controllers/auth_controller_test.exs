defmodule LibTenWeb.AuthControllerTest do
  use LibTenWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Login with google"
  end

  @tag :skip
  test "GET /auth/google" do
  end

  @tag :skip
  test "GET /auth/google/callback" do
  end

  @tag :skip
  test "GET /auth/sign_out" do
  end
end
