defmodule LibTen.Categories do
  import Ecto.Query, warn: false

  alias LibTen.Repo
  alias LibTen.Categories.Category

  def list_categories do
    Category
    |> order_by(:inserted_at)
    |> Repo.all()
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    category
    |> Category.delete_changeset()
    |> Repo.delete()
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
