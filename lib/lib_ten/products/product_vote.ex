defmodule LibTen.Products.ProductVote do
  use Ecto.Schema

  import Ecto.Changeset

  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductVote}

  schema "product_votes" do
    belongs_to :product, Product
    belongs_to :user, User
    field :is_upvote, :boolean

    timestamps()
  end

  @doc false
  def changeset(%ProductVote{} = product_vote, attrs) do
    product_vote
    |> cast(attrs, [:user_id, :product_id, :is_upvote])
    |> unique_constraint(:product_id,
      name: :product_ratings_product_id_user_id_index,
      message: "Can't vote with same value"
    )
  end
end
