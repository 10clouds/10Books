defmodule LibTenWeb.Products.AllChannel do
  use Phoenix.Channel
  import LibTenWeb.Products.ChannelHelpers
  alias LibTen.Products.All

  def join("products:all", _message, socket) do
    if socket.assigns.user.is_admin do
      products = LibTenWeb.ProductsView.render("index.json", products: All.list())
      {:ok, %{payload: products}, socket}
    else
      {:error, %{reason: :unauthorized}}
    end
  end

  def handle_in("create", %{"attrs" => attrs}, socket) do
    All.create(attrs, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("force_return", %{"id" => product_id}, socket) do
    All.force_return(product_id)
    |> make_reply(socket)
  end

  def handle_in("update", %{"id" => product_id, "attrs" => attrs}, socket) do
    All.update(product_id, attrs)
    |> make_reply(socket)
  end

  def broadcast_update(product_id) do
    broadcast_update("all", product_id, All.get(product_id))
  end
end
