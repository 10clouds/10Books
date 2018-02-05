defmodule LibTenWeb.Products.ChannelHelpers do
  def broadcast_update(channel, product_id, product) do
    if product do
      LibTenWeb.Endpoint.broadcast(
        "products:" <> channel,
        "updated",
        LibTenWeb.ProductsView.render("show.json", product: product)
      )
    else
      LibTenWeb.Endpoint.broadcast("products:" <> channel, "deleted", %{
        id: product_id
      })
    end
  end

  def make_reply(ecto_result, socket) do
    case ecto_result do
      {:ok, record} -> {:reply, {:ok, %{id: record.id}}, socket}
      {:error, changeset} -> make_error_reply(socket, changeset)
      nil -> make_error_reply(socket, %{type: :not_found})
    end
  end

  def make_error_reply(socket, error) do
    response = LibTenWeb.ErrorView.render("error.json", error)
    {:reply, {:error, response}, socket}
  end
end
