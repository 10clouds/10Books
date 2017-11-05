defmodule LibTenWeb.ProductsChannel do
  use Phoenix.Channel

  alias LibTen.Products
  alias LibTen.Products.Product

  def join("products", _message, socket) do
    products = Enum.map(Products.list_products(), &(Product.to_map(&1)))
    {:ok, %{payload: products}, socket}
  end

  def handle_in("create", %{"attrs" => attrs}, socket) do
    build_response(socket, Products.create_product(attrs))
  end

  def handle_in("update", %{"id" => id, "attrs" => attrs}, socket) do
    product = Products.get_product!(id)
    build_response(socket, Products.update_product(product, attrs))
  end

  def handle_in("delete", %{"id" => id}, socket) do
    build_response(socket, Products.delete_product(id))
  end

  defp build_response(socket, context_result) do
    case context_result do
      {:ok, product} ->
        response = Product.to_map(product)
        {:reply, {:ok, response}, socket}
      {:error, changeset} ->
        response = LibTenWeb.ChangesetView.render("errors.json", %{
          changeset: changeset
        })
        {:reply, {:error, response}, socket}
    end
  end
end
