defmodule LibTen.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias LibTen.Repo

  alias LibTen.Products.{Product, ProductUse, ProductRating, ProductVote}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(products_query())
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    query = from product in products_query(),
      where: product.id == ^id
    Repo.one!(query)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    case %Product{}
         |> Product.changeset(attrs)
         |> Repo.insert()
    do
      {:ok, product} -> broadcast_change("created", product)
      error -> error
    end
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    case product
         |> Product.changeset(attrs)
         |> Repo.update()
    do
      {:ok, product} -> broadcast_change("updated", product)
      error -> error
    end
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    case Repo.delete(product) do
      {:ok, product} -> broadcast_change("deleted", product)
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end


  def take_product(product_id, user_id) do
    changeset = %{product_id: product_id, user_id: user_id}

    case %ProductUse{}
         |> ProductUse.changeset(changeset)
         |> Repo.insert()
    do
      {:ok, _} ->
        product = get_product!(product_id)
        broadcast_change("updated", product)
      error -> error
    end
  end


  def return_product(product_id, user_id) do
    query = from product_use in ProductUse,
      where: product_use.product_id == ^product_id,
      where: product_use.user_id == ^user_id,
      where: is_nil(product_use.ended_at)
    product_use = Repo.one!(query)

    case product_use
         |> ProductUse.changeset(%{ended_at: DateTime.utc_now})
         |> Repo.update()
    do
      {:ok, _} ->
        product = get_product!(product_id)
        broadcast_change("updated", product)
      error -> error
    end
  end


  def rate_product(product_id, user_id, rating) do
    changeset = %{
      product_id: product_id,
      user_id: user_id,
      rating: rating
    }

    case %ProductRating{}
         |> ProductRating.changeset(changeset)
         |> Repo.insert()
    do
      {:ok, _} ->
        product = get_product!(product_id)
        broadcast_change("updated", product)
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
      {:ok, _} ->
        product = get_product!(product_id)
        broadcast_change("updated", product)
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
      rating: product.rating,
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
          %ProductUse{} ->
            %{
              started_at: product.product_use.inserted_at,
              user_name: product.product_use.user.name
            }
          _ -> nil
        end
    }
  end


  def to_json_map(products) do
    Enum.map(products, &to_json_map/1)
  end


  defp products_query do
    # TODO: optimize query, so we won't have subqueries
    # TODO: learn how to extend queries, so we won't need to insert directyly to
    # association records
    from product in Product,
      left_join: product_use in ProductUse,
        on: product_use.product_id == product.id,
        on: is_nil(product_use.ended_at),
      preload: [product_use: {product_use, :user}],
      preload: [product_votes: :user],
      select_merge: %{
        rating: fragment(
          "(SELECT AVG(rating) FROM product_ratings WHERE product_ratings.product_id = ?)",
          product.id
        )
      },
      order_by: [desc: product.inserted_at]
  end


  defp broadcast_change(type, %Product{} = product) do
    LibTenWeb.Endpoint.broadcast!("products", type, to_json_map(product))
    {:ok, product}
  end
end
