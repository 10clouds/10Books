defmodule LibTenWeb.PostgresListener do
  use Boltun, otp_app: :lib_ten

  listen do
    channel "product_updated", :on_record_change
    channel "category_updated", :on_record_change
  end

  def on_record_change("product_updated", id) do
    [
      LibTenWeb.Products.LibraryChannel,
      LibTenWeb.Products.OrdersChannel,
      LibTenWeb.Products.AllChannel
    ]
    |> Enum.map(
      &Task.async(fn ->
        id
        |> String.to_integer()
        |> &1.broadcast_update
      end)
    )
    |> Enum.map(&Task.await/1)
  end

  def on_record_change("category_updated", id) do
    id
    |> String.to_integer()
    |> LibTenWeb.CategoriesChannel.broadcast_update()
  end
end
