defmodule LibTenWeb.ProductsController do
  use LibTenWeb, :controller

  def library(conn, _params) do
    render(conn, "library.html")
  end

  def orders(conn, _params) do
    render(conn, "orders.html")
  end

  def all(conn, _params) do
    render(conn, "all.html")
  end
end
