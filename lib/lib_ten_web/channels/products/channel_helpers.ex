defmodule LibTenWeb.Products.ChannelHelpers do
  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductUse}

  def broadcast_update(channel, product_id, product) do
    if product do
      LibTenWeb.Endpoint.broadcast("products:" <> channel, "updated", to_json_map(product))
    else
      LibTenWeb.Endpoint.broadcast("products:" <> channel, "deleted", %{
        id: product_id
      })
    end
  end

  def make_reply(ecto_result, socket) do
    case ecto_result do
      {:ok, record} -> {:reply, {:ok, %{id: record.id}}, socket}
      {:error, changeset} -> make_error_reply(socket, changeset)
      nil -> make_error_reply(socket, %{type: :not_found})
    end
  end

  def make_error_reply(socket, error) do
    response = LibTenWeb.ErrorView.render("error.json", error)
    {:reply, {:error, response}, socket}
  end

  # TODO: Use view insted
  # TODO: This can be written with less code
  def to_json_map(%Product{} = product) do
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
          %User{} = user -> %{id: user.id, name: user.name}
          _ -> nil
        end,
      ratings:
        if is_list(product.ratings) do
          Enum.map(product.ratings, fn rating ->
            %{
              user: %{
                id: rating.user.id,
                name: rating.user.name
              },
              value: rating.value
            }
          end)
        else
          []
        end,
      votes:
        if is_list(product.votes) do
          Enum.map(product.votes, fn vote ->
            %{
              user: %{
                id: vote.user.id,
                name: vote.user.name
              },
              is_upvote: vote.is_upvote
            }
          end)
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
                name: used_by.user.name
              },
              return_subscribers: used_by.return_subscribers
            }

          _ ->
            nil
        end
    }
  end

  def to_json_map(products) do
    Enum.map(products, &to_json_map/1)
  end
end
