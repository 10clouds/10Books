defmodule LibTenWeb.Products.LibraryChannel do
  use Phoenix.Channel
  import LibTenWeb.Products.ChannelHelpers
  alias LibTen.Products.Library

  def join("products:library", _message, socket) do
    products = Library.list() |> to_json_map
    {:ok, %{payload: products}, socket}
  end

  def handle_in("update", %{"id" => product_id, "attrs" => attrs}, socket) do
    Library.update(product_id, attrs)
    |> make_reply(socket)
  end

  def handle_in("take", %{"id" => product_id}, socket) do
    Library.take(product_id, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("return", %{"id" => product_id}, socket) do
    Library.return(product_id, socket.assigns.user.id)
    |> make_reply(socket)
  end

  def handle_in("rate", %{"id" => product_id, "value" => value}, socket) do
    Library.rate(product_id, socket.assigns.user.id, value)
    |> make_reply(socket)
  end

  def broadcast_update(product_id) do
    broadcast_update("library", product_id, Library.get(product_id))
  end
end
