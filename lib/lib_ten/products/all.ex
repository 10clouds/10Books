defmodule LibTen.Products.All do
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LibTen.Repo
  alias LibTen.Products.{Product, ProductUse}

  def list do
    Product
    |> join(:left, [p], used_by in assoc(p, :used_by), on: is_nil(used_by.ended_at))
    |> preload([_, used_by], used_by: {used_by, :user})
    |> preload(:requested_by_user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get(product_id) do
    Product
    |> join(:left, [p], used_by in assoc(p, :used_by), on: is_nil(used_by.ended_at))
    |> preload([_, used_by], used_by: {used_by, :user})
    |> preload(:requested_by_user)
    |> Repo.get(product_id)
  end

  def create(attrs, current_user_id) do
    %Product{}
    |> Product.changeset_for_role(attrs, "admin")
    |> Changeset.put_change(:requested_by_user_id, current_user_id)
    |> Repo.insert()
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

  def force_return(product_id) do
    curr_use =
      ProductUse
      |> where(product_id: ^product_id)
      |> where([p], is_nil(p.ended_at))
      |> Repo.one()

    if curr_use do
      curr_use
      |> ProductUse.changeset(%{ended_at: DateTime.utc_now()})
      |> Repo.update()
    else
      {:error, "Can't find product usage"}
    end
  end
end
