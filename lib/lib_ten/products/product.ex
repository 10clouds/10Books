defmodule LibTen.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibTen.Products.Product

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
    belongs_to :category, LibTen.Categories.Category

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:title, :url, :author, :status, :category_id])
    |> validate_required([:title, :url, :author, :status])
    |> validate_url(:url, %{message: "Invalid url"})
    |> validate_inclusion(:status, @valid_statuses)
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, _} -> [{field, options[:message]}]
      end
    end
  end

  # TODO: 100% the's a helper for this
  def to_map(%Product{} = product) do
    %{
      id: product.id,
      title: product.title,
      url: product.url,
      author: product.author,
      status: product.status,
      category_id: product.category_id
    }
  end
end
