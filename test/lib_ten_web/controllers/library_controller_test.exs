defmodule LibTenWeb.LibraryControllerTest do
  use LibTenWeb.ConnCase

  test "GET /library", %{conn: conn} do
    conn = get conn, "/library"
    assert html_response(conn, 200) =~ "library"
  end
end
