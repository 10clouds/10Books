defmodule LibTenWeb.Products.OrdersChannel do
  use Phoenix.Channel
  import LibTenWeb.Products.ChannelHelpers
  alias LibTen.Products.Orders

  def join("products:orders", _message, socket) do
    products = LibTenWeb.ProductsView.render("index.json", products: Orders.list())
    {:ok, %{payload: products}, socket}
  end

  def handle_in("update", %{"id" => product_id, "attrs" => attrs}, socket) do
    role = if socket.assigns.user.is_admin, do: "admin", else: "user"

    Orders.update(product_id, attrs, role, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("create", %{"attrs" => attrs}, socket) do
    Orders.create(attrs, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("upvote", %{"id" => product_id}, socket) do
    Orders.upvote(product_id, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("downvote", %{"id" => product_id}, socket) do
    Orders.downvote(product_id, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def broadcast_update(product_id) do
    broadcast_update("orders", product_id, Orders.get(product_id))
  end
end
