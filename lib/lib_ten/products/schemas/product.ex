defmodule LibTen.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductUse, ProductVote, ProductRating}
  alias LibTen.Categories.Category

  # TODO:
  # Ideally we want to have separate schema for each context (library/orders/all)
  # and some common base
  def library_statuses,
    do: [
      "IN_LIBRARY"
    ]

  def order_statuses,
    do: [
      "REQUESTED",
      "ACCEPTED",
      "REJECTED",
      "ORDERED"
    ]

  def archived_statuses,
    do: [
      "LOST",
      "DELETED"
    ]

  def valid_statuses do
    library_statuses()
    |> Enum.concat(order_statuses())
    |> Enum.concat(archived_statuses())
  end

  schema "products" do
    field :author, :string
    field :status, :string
    field :title, :string
    field :url, :string
    belongs_to :category, Category
    belongs_to :requested_by_user, User
    # TODO: re-check this
    has_one :used_by, ProductUse, on_replace: :delete
    has_many :votes, ProductVote
    has_many :ratings, ProductRating

    timestamps(type: :utc_datetime)
  end

  def changeset_for_role(%Product{} = product, attrs, "user") do
    product
    |> cast(attrs, [:title, :url, :author, :category_id])
    |> validate_required([:title, :url, :author])
    |> validate_url
  end

  def changeset_for_role(%Product{} = product, attrs, "admin") do
    product
    |> cast(attrs, [:title, :url, :author, :status, :category_id])
    |> validate_required([:title, :url, :author])
    |> validate_url
    |> validate_inclusion(:status, valid_statuses())
  end

  defp validate_url(changeset) do
    validate_change(changeset, :url, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, _} -> [{:url, %{message: "Invalid url"}}]
      end
    end)
  end
end
