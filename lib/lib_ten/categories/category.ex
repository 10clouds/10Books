defmodule LibTen.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibTen.Categories.Category


  schema "categories" do
    field :name, :string
    has_many :products, LibTen.Products.Product, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
