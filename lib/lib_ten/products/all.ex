defmodule LibTen.Products.All do
  import Ecto.Query, warn: false
  alias LibTen.Repo
  alias LibTen.Products.Product

  def list do
    Product
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get(product_id) do
    Repo.get(Product, product_id)
  end

  def update(product_id, attrs) do
    product = get(product_id)

    if product do
      product
      |> Product.changeset_for_role(attrs, "admin")
      |> Repo.update()
    else
      nil
    end
  end
end
