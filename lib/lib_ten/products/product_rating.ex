defmodule LibTen.Products.ProductRating do
  use Ecto.Schema

  import Ecto.Changeset

  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductRating}

  schema "product_ratings" do
    field :rating, :float
    belongs_to :product, Product
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%ProductRating{} = product_rating, attrs) do
    product_rating
    |> cast(attrs, [:user_id, :product_id, :rating])
    |> validate_number(:rating,
        greater_than_or_equal_to: 1,
        less_than_or_equal_to: 5)
    |> unique_constraint(:product_id,
      name: :product_ratings_product_id_user_id_index,
      message: "Already rated"
    )
  end
end
