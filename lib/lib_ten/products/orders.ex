defmodule LibTen.Products.Orders do
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LibTen.Repo
  alias LibTen.Products.{Product, ProductVote}

  def list do
    orders_query()
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get(product_id, with_preloads \\ true) do
    orders_query(with_preloads)
    |> Repo.get(product_id)
  end

  def create(attrs, requested_by_user_id) do
    %Product{}
    |> Product.changeset_for_role(attrs, "user")
    |> Changeset.validate_required([:category_id])
    |> Changeset.put_change(:status, "REQUESTED")
    |> Changeset.put_change(:requested_by_user_id, requested_by_user_id)
    |> Repo.insert()
  end

  def update(product_id, attrs, role, perfomed_by_user_id) do
    product = get(product_id, false)

    if product do
      changeset = Product.changeset_for_role(product, attrs, role)

      changeset =
        if role == "user" && product.requested_by_user_id == perfomed_by_user_id &&
             attrs["status"] && attrs["status"] == "DELETED" do
          Changeset.put_change(changeset, :status, "DELETED")
        else
          changeset
        end

      Repo.update(changeset)
    else
      nil
    end
  end

  def upvote(product_id, user_id), do: vote(product_id, user_id, true)
  def downvote(product_id, user_id), do: vote(product_id, user_id, false)

  defp vote(product_id, user_id, is_upvote) do
    product = get(product_id, false)

    if product do
      (Repo.get_by(
         ProductVote,
         product_id: product_id,
         user_id: user_id
       ) || %ProductVote{})
      |> ProductVote.changeset(%{
        product_id: product_id,
        user_id: user_id,
        is_upvote: is_upvote
      })
      |> Repo.insert_or_update()
    else
      nil
    end
  end

  defp orders_query(with_preloads \\ true) do
    query = where(Product, [p], p.status in ^Product.order_statuses())

    case with_preloads do
      true ->
        query
        |> preload(:requested_by_user)
        |> preload(votes: :user)

      false ->
        query
    end
  end
end
