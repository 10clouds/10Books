defmodule LibTen.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias LibTen.Repo

  alias LibTen.Products.{Product, ProductUses, ProductUse, ProductRating, ProductVote}


  def list_products do
    Repo.all(products_query())
  end


  def get_product!(id) do
    query = from product in products_query(),
      where: product.id == ^id
    Repo.one!(query)
  end


  def create_product(attrs \\ %{}) do
    case %Product{}
         |> Product.changeset(attrs)
         |> Repo.insert()
    do
      {:ok, product} -> broadcast_change("created", product)
      error -> error
    end
  end


  def update_product(%Product{} = product, attrs) do
    case product
         |> Product.changeset(attrs)
         |> Repo.update()
    do
      {:ok, product} -> broadcast_change("updated", product)
      error -> error
    end
  end


  def delete_product(%Product{} = product) do
    case product
         |> Product.changeset(%{deleted: true})
         |> Repo.update()
    do
      {:ok, product} -> broadcast_change("deleted", product)
      error -> error
    end
  end


  def take_product(product_id, user_id) do
    case ProductUses.take_product(product_id, user_id) do
      {:ok, _} -> broadcast_change("updated", product_id)
      error -> error
    end
  end


  def return_product(product_id, user_id) do
    case ProductUses.return_product(product_id, user_id) do
      {:ok, _} -> broadcast_change("updated", product_id)
      error -> error
    end
  end


  def rate_product(product_id, user_id, rating) do
    changeset = %{
      product_id: product_id,
      user_id: user_id,
      value: rating
    }

    case %ProductRating{}
         |> ProductRating.changeset(changeset)
         |> Repo.insert()
    do
      {:ok, _} -> broadcast_change("updated", product_id)
      error -> error
    end
  end


  def vote_for_product(product_id, user_id, is_upvote) do
    changeset = %{
      product_id: product_id,
      user_id: user_id,
      is_upvote: is_upvote
    }

    existing_vote = Repo.get_by(ProductVote,
      user_id: user_id, product_id: product_id
    )

    result = if existing_vote do
      existing_vote
      |> ProductVote.changeset(changeset)
      |> Repo.update()
    else
      %ProductVote{}
       |> ProductVote.changeset(changeset)
       |> Repo.insert()
    end

    case result do
      {:ok, _} -> broadcast_change("updated", product_id)
      error -> error
    end
  end


  def to_json_map(%Product{} = product) do
    %{
      id: product.id,
      title: product.title,
      url: product.url,
      author: product.author,
      status: product.status,
      category_id: product.category_id,
      ratings:
        if is_list(product.product_ratings) do
          Enum.map(product.product_ratings, fn(rating) ->
            %{
              user: %{
                id: rating.user.id,
                name: rating.user.name
              },
              value: rating.value
            }
          end)
        else
          []
        end,
      votes:
        if is_list(product.product_votes) do
          Enum.map(product.product_votes, fn(vote) ->
            %{
              user: %{
                id: vote.user.id,
                name: vote.user.name
              },
              is_upvote: vote.is_upvote
            }
          end)
        else
          []
        end,
      in_use:
        case product.product_use do
          %ProductUse{} = product_use ->
            %{
              started_at: product_use.inserted_at,
              user_name: product_use.user.name,
              return_subscribers: product_use.return_subscribers
            }
          _ -> nil
        end
    }
  end


  def to_json_map(products) do
    Enum.map(products, &to_json_map/1)
  end


  defp products_query do
    # TODO: learn how to extend queries, so we won't need to insert directyly to
    # association records
    # TODO: Optimize perfomance
    from product in Product,
      left_join: product_use in ProductUse,
        on: product_use.product_id == product.id,
        on: is_nil(product_use.ended_at),
      preload: [product_use: {product_use, :user}],
      preload: [product_votes: :user],
      preload: [product_ratings: :user],
      where: product.deleted != true,
      order_by: [desc: product.inserted_at]
  end

  defp broadcast_change(type, %Product{} = product) do
    LibTenWeb.Endpoint.broadcast!("products", type, to_json_map(product))
    {:ok, product}
  end

  defp broadcast_change(type, product_id) do
    product = get_product!(product_id)
    broadcast_change(type, product)
  end
end
