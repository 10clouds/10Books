defmodule LibTen.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias LibTen.Repo

  alias LibTen.Categories.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    case %Category{}
         |> Category.changeset(attrs)
         |> Repo.insert()
    do
      {:ok, category} -> broadcast_change("created", category)
      error -> error
    end
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    case category
         |> Category.changeset(attrs)
         |> Repo.update()
    do
      {:ok, category} -> broadcast_change("updated", category)
      error -> error
    end
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    case Repo.delete(category) do
      {:ok, category} -> broadcast_change("deleted", category)
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  defp broadcast_change(type, %Category{} = category) do
    LibTenWeb.Endpoint.broadcast!("categories", type, Category.to_map(category))
    {:ok, category}
  end
end
