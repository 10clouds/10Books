defmodule LibTenWeb.ProductsChannel do
  use Phoenix.Channel

  alias LibTen.Products
  alias LibTen.Products.Product
  alias LibTen.Categories

  def join("products:all", _message, socket) do
    initial_data = %{
      categories: Enum.map(
        LibTen.Categories.list_categories(),
        &(category_to_map(&1))
      ),
      products: Enum.map(
        LibTen.Products.list_products(),
        &(product_to_map(&1))
      )
    }
    {:ok, initial_data, socket}
  end

  def handle_in("product:updated", %{"id" => id, "attrs" => attrs}, socket) do
    case Products.update_product(Products.get_product!(id), attrs) do
      {:ok, product} ->
        broadcast! socket, "product:updated", product_to_map(product)
        {:noreply, socket}
      {:error, _} -> {:noreply, socket}
    end
  end

  defp category_to_map(category) do
    IO.inspect(category)
    %{id: category.id, name: category.name}
  end

  defp product_to_map(product) do
    IO.inspect(product)
    %{
      id: product.id,
      title: product.title,
      url: product.url,
      author: product.author,
      status: product.status,
      category_id: product.category_id
    }
  end
end
