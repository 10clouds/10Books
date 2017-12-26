defmodule LibTen.Products.ProductUses do
  import Ecto.Query

  alias LibTen.Repo
  alias LibTen.Products.ProductUse


  # TODO: Separate contxt in lib_ten ?


  def take_product(product_id, user_id) do
    %ProductUse{}
    |> ProductUse.changeset(%{product_id: product_id, user_id: user_id})
    |> Repo.insert()
  end


  def return_product(product_id, user_id) do
    active_product_use_query(product_id)
    |> where(user_id: ^user_id)
    |> Repo.one!
    |> ProductUse.changeset(%{ended_at: DateTime.utc_now})
    |> Repo.update()
  end


  def subscribe_to_product_return(product_id, user_id) do
    product_use = Repo.one!(active_product_use_query(product_id))
    changeset = %{
      return_subscribers: product_use.return_subscribers ++ [user_id]
    }

    product_use
    |> ProductUse.changeset(changeset)
    |> Repo.update()
  end


  def unsubscribe_from_product_return(product_id, user_id) do
    product_use = Repo.one!(active_product_use_query(product_id))
    changeset = %{
      return_subscribers: List.delete(product_use.return_subscribers, user_id)
    }

    product_use
    |> ProductUse.changeset(changeset)
    |> Repo.update()
  end


  defp active_product_use_query(product_id) do
    ProductUse
    |> where(product_id: ^product_id)
    |> where([p], is_nil(p.ended_at))
  end
end
