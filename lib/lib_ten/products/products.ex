defmodule LibTen.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias LibTen.Repo

  alias LibTen.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
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
  def get_product!(id), do: Repo.get!(Product, id)

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

  defp broadcast_change(type, %Product{} = product) do
    LibTenWeb.Endpoint.broadcast!("products", type, Product.to_map(product))
    {:ok, product}
  end
end
