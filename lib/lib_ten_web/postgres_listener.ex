defmodule LibTenWeb.PostgresListener do
  use Boltun, otp_app: :lib_ten

  listen do
    channel "product_updated", :on_product_updated
    channel "category_updated", :on_category_updated
  end

  def on_product_updated("product_updated", product_id) do
    IO.puts "db product_updated ----> product_id=#{product_id}"
  end

  def on_category_updated("category_updated", category_id) do
    LibTenWeb.CategoriesChannel.broadcast_update(category_id)
  end
end
