defmodule LibTenWeb.ProductsControllerTest do
  use LibTenWeb.ConnCase

  import LibTen.Factory

  describe "Authenticated users" do
    setup %{conn: conn} do
      user = insert(:user)
      signed_in_conn = sign_in(conn, user)
      {:ok, %{conn: signed_in_conn}}
    end

    test "GET /library", %{conn: conn} do
      conn = get conn, "/library"
      assert html_response(conn, 200) =~ "products-table"
    end

    test "GET /orders", %{conn: conn} do
      conn = get conn, "/orders"
      assert html_response(conn, 200) =~ "products-table"
    end

    test "GET /admin/products", %{conn: conn} do
      conn = get conn, "/admin/products"
      assert html_response(conn, 404)
    end
  end


  describe "Admin only" do
    setup %{conn: conn} do
      user = insert(:user, is_admin: true)
      signed_in_conn = sign_in(conn, user)
      {:ok, %{conn: signed_in_conn}}
    end

    test "GET /admin/products", %{conn: conn} do
      conn = get conn, "/admin/products"
      assert html_response(conn, 200) =~ "products-table"
    end
  end
end
