defmodule LibTenWeb.ProductsView do
  use LibTenWeb, :view
  alias LibTen.Accounts.User
  alias LibTen.Products.ProductUse

  def render("index.json", %{products: products} = _assigns) do
    Enum.map(products, &render_product/1)
  end

  def render("show.json", %{product: product} = _assigns) do
    render_product(product)
  end

  defp render_product(product) do
    %{
      inserted_at: DateTime.to_unix(product.inserted_at, :millisecond),
      id: product.id,
      title: product.title,
      url: product.url,
      author: product.author,
      status: product.status,
      category_id: product.category_id,
      requested_by:
        case product.requested_by_user do
          %User{} = user -> Map.take(user, [:id, :name])
          _ -> nil
        end,
      ratings:
        if is_list(product.ratings) do
          Enum.map product.ratings, fn rating ->
            %{
              user: %{
                id: rating.user.id,
                name: rating.user.name
              },
              value: rating.value
            }
          end
        else
          []
        end,
      votes:
        if is_list(product.votes) do
          Enum.map product.votes, fn vote ->
            %{
              user: %{
                id: vote.user.id,
                name: vote.user.name
              },
              is_upvote: vote.is_upvote
            }
          end
        else
          []
        end,
      used_by:
        case product.used_by do
          %ProductUse{} = used_by ->
            %{
              started_at: used_by.inserted_at,
              user: %{
                id: used_by.user.id,
                name: used_by.user.name,
                avatar_url: used_by.user.avatar_url <> "?sz=60"
              },
              return_subscribers: used_by.return_subscribers
            }
          _ -> nil
        end
    }
  end
end
