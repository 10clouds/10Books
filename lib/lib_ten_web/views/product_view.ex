defmodule LibTenWeb.ProductView do
  use LibTenWeb, :view

  alias LibTen.Products.Product

  def status_select_options do
    [
      'In Library': Enum.map(Product.library_statuses, fn {_, v} -> v end),
      'In Orders': Enum.map(Product.order_statuses, fn {_, v} -> v end)
    ]
  end
end
