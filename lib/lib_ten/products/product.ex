defmodule LibTen.Products.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductUse, ProductVote}
  alias LibTen.Categories.Category

  @library_statuses [
    in_library: "IN_LIBRARY",
    lost: "LOST"
  ]
  def library_statuses, do: @library_statuses

  @order_statuses [
    requested: "REQUESTED",
    accepted: "ACCEPTED",
    rejected: "REJECTED",
    ordered: "ORDERED"
  ]
  def order_statuses, do: @order_statuses

  @valid_statuses Enum
    .concat(@library_statuses, @order_statuses)
    |> Enum.map(fn {_, v} -> v end)

  schema "products" do
    field :author, :string
    field :status, :string
    field :title, :string
    field :url, :string
    field :deleted, :boolean, default: false
    belongs_to :category, Category
    belongs_to :user, User
    has_one :product_use, ProductUse, on_replace: :delete # TODO: re-check this
    has_many :product_votes, ProductVote
    field :rating, :float, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [
        :title,
        :url,
        :author,
        :status,
        :category_id,
        :user_id,
        :deleted])
    |> cast_assoc(:product_use)
    |> validate_required([:title, :url, :author, :status])
    |> validate_url(:url, %{message: "Invalid url"})
    |> validate_inclusion(:status, @valid_statuses)
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_charlist |> :http_uri.parse do
        {:ok, _} -> []
        {:error, _} -> [{field, options[:message]}]
      end
    end
  end
end
