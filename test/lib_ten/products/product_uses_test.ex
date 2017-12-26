defmodule LibTen.ProductUsesTest do
  use LibTen.DataCase

  import LibTen.Factory
  import Mock

  alias LibTen.Repo
  alias LibTen.Products.{ProductUses, ProductUse}

  test "take_product/2 creates new recrod unless same product_id & ended_at=nil present" do
    user = insert(:user)
    product = insert(:product, product_use: nil)
    assert {:ok, %ProductUse{} = product_use} = ProductUses.take_product(product.id, user.id)
    assert product_use.product_id == product.id
    assert product_use.user_id == user.id
    assert product_use.ended_at == nil
    assert {:error, %Ecto.Changeset{}} = ProductUses.take_product(product.id, user.id)
  end


  test "return_product/2 updates existing product ended_at if it's present" do
    date_now = DateTime.utc_now
    naive_date_now = DateTime.to_naive(date_now)
    user = insert(:user)
    product = insert(:product, product_use: %{user_id: user.id})

    with_mock DateTime, [utc_now: fn -> date_now end] do
      assert {:ok, %ProductUse{} = product_use} = ProductUses.return_product(product.id, user.id)
      assert product_use.ended_at == naive_date_now
    end
  end


  test "subscribe_to_product_return/2 add user to return_subscribers" do
    user = insert(:user)
    user2 = insert(:user)
    product = insert(:product,
      product_use: %{
        user: user
      }
    )

    ProductUses.subscribe_to_product_return(product.id, user.id)
    ProductUses.subscribe_to_product_return(product.id, user2.id)

    product_use = Repo.get_by!(ProductUse, product_id: product.id)
    assert product_use.return_subscribers == [user.id, user2.id]
  end


  test "unsubscribe_from_product_return/2 removes user from return_subscribers" do
    user = insert(:user)
    user2 = insert(:user)
    product = insert(:product,
      product_use: %{
        user: user,
        return_subscribers: [user.id, user2.id]
      }
    )

    ProductUses.unsubscribe_from_product_return(product.id, user.id)

    product_use = Repo.get_by!(ProductUse, product_id: product.id)
    assert product_use.return_subscribers == [user2.id]
  end
end
