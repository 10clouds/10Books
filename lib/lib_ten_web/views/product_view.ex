defmodule LibTenWeb.ProductView do
  use LibTenWeb, :view

  alias LibTen.Products.Product
  alias LibTen.Categories

  def status_select_options do
    [
      'In Library': Enum.map(Product.library_statuses, fn {_, v} -> v end),
      'In Orders': Enum.map(Product.order_statuses, fn {_, v} -> v end)
    ]
  end

  def categories_as_options do
    Enum.map(Categories.list_categories(), &{&1.name, &1.id})
  end
end
