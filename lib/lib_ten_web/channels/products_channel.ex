defmodule LibTenWeb.ProductsChannel do
  use Phoenix.Channel

  alias LibTen.Products
  alias LibTenWeb.ErrorView


  def join("products", _message, socket) do
    products = Products.list_products() |> Products.to_json_map
    {:ok, %{payload: products}, socket}
  end


  def handle_in("create", %{"attrs" => attrs}, socket) do
    build_response(socket, Products.create_product(attrs))
  end


  def handle_in("update", %{"id" => id, "attrs" => attrs}, socket) do
    try do
      product = Products.get_product!(id)
      build_response(socket, Products.update_product(product, attrs))
    rescue
      Ecto.NoResultsError -> reply_with_error(socket, %{type: :not_found})
    end
  end


  def handle_in("delete", %{"id" => id}, socket) do
    try do
      product = Products.get_product!(id)
      build_response(socket, Products.delete_product(product))
    rescue
      Ecto.NoResultsError -> reply_with_error(socket, %{type: :not_found})
    end
  end


  def handle_in("take", %{"id" => id}, socket) do
    product = Products.take_product(id, socket.assigns[:user_id])
    build_response(socket, product)
  end


  def handle_in("return", %{"id" => id}, socket) do
    try do
      product = Products.return_product(id, socket.assigns[:user_id])
      build_response(socket, product)
    rescue
      Ecto.NoResultsError -> reply_with_error(socket, %{type: :not_found})
    end
  end


  defp reply_with_error(socket, error) do
    response = ErrorView.render("error.json", error)
    {:reply, {:error, response}, socket}
  end

  defp build_response(socket, context_result) do
    case context_result do
      {:ok, product} ->
        response = Products.to_json_map(product)
        {:reply, {:ok, response}, socket}
      {:error, changeset} -> reply_with_error(socket, changeset)
    end
  end
end
