defmodule LibTen.Products.ProductRating do
  use LibTen.Schema

  import Ecto.Changeset

  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductRating}

  schema "product_ratings" do
    field :value, :float
    belongs_to :product, Product
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%ProductRating{} = product_rating, attrs) do
    product_rating
    |> cast(attrs, [:user_id, :product_id, :value])
    |> validate_number(
      :value,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    )
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(
      :product_id,
      name: :product_ratings_product_id_user_id_index,
      message: "Already rated"
    )
  end
end
