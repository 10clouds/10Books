defmodule LibTen.Products.LibraryTest do
  use LibTen.DataCase
  import LibTen.Factory
  import Mock
  alias LibTen.Products.ProductUse
  alias LibTen.Products.Library

  test "list/0 returns only products with library status sorted by inserted_at" do
    product1 = insert(:product,
      status: "IN_LIBRARY",
      inserted_at: ~N[2000-01-01 00:00:00.000000],
      used_by: %{user: insert(:user)},
      ratings: [%{user: insert(:user), value: 2.5}]
    )
    product2 = insert(:product,
      status: "IN_LIBRARY",
      inserted_at: ~N[2000-01-01 00:01:00.000000],
      used_by: %{user: insert(:user)},
      ratings: [%{user: insert(:user), value: 4.5}]
    )
    insert(:product)
    assert Library.list() == [product2, product1]
  end


  test "get/1 returns product if it has library status" do
    product1 = insert(:product, status: "IN_LIBRARY", used_by: nil, ratings: [])
    product2 = insert(:product)
    assert Library.get(product1.id) == product1
    assert Library.get(product2.id) == nil
  end


  test "get/1 returns last used_by if multiple are in db" do
    user1 = insert(:user)
    user2 = insert(:user)
    product = insert(:product, status: "IN_LIBRARY")
    assert {:ok, _} = Library.take(product.id, user1.id)
    assert {:ok, _} = Library.return(product.id, user1.id)
    assert {:ok, _} = Library.take(product.id, user2.id)
    product = Library.get(product.id)
    assert product.used_by.user == user2
    assert product.used_by.ended_at == nil
  end


  describe "update/2" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      assert Library.update(product.id, %{category_id: 1}) == nil
    end

    test "returns {:ok, product} if product with given id is in library" do
      product = insert(:product, status: "IN_LIBRARY")
      category = insert(:category)
      {:ok, updated_product} = Library.update(product.id, %{category_id: category.id})
      assert updated_product.category_id == category.id
    end
  end


  describe "take/2" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      user = insert(:user)
      assert Library.take(product.id, user.id) == nil
    end

    test "creates new used_by unless same product_id & ended_at=nil present" do
      user = insert(:user)
      product = insert(:product, status: "IN_LIBRARY")
      assert {:ok, _} = Library.take(product.id, user.id)
      product = Library.get(product.id)
      assert product.used_by.user == user
      assert product.used_by.ended_at == nil
      assert {:error, %Ecto.Changeset{}} = Library.take(product.id, user.id)
    end
  end


  describe "return/2" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      user = insert(:user)
      assert Library.return(product.id, user.id) == nil
    end

    test "updates existing used_by.ended_at if it's present" do
      date_now = DateTime.utc_now
      naive_date_now = DateTime.to_naive(date_now)
      user = insert(:user)
      product = insert(:product, status: "IN_LIBRARY", used_by: %{user: user})

      with_mock DateTime, [utc_now: fn -> date_now end] do
        assert {:ok, _} = Library.return(product.id, user.id)
        product = Library.get(product.id)
        product_use = Repo.get_by(ProductUse, product_id: product.id)
        assert product.used_by == nil
        assert product_use.user_id == user.id
        assert product_use.ended_at == naive_date_now
      end
    end
  end


  describe "rate/3" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      user = insert(:user)
      assert Library.rate(product.id, user.id, 2.5) == nil
    end

    test "adds user rating" do
      user = insert(:user)
      user2 = insert(:user)
      product = insert(:product, status: "IN_LIBRARY")
      Library.rate(product.id, user.id, 4.5)
      Library.rate(product.id, user2.id, 2.5)
      product = Library.get(product.id)
      rating1 = Enum.at(product.ratings, 0)
      rating2 = Enum.at(product.ratings, 1)

      assert rating1.user_id == user.id
      assert rating1.value == 4.5
      assert rating2.user_id == user2.id
      assert rating2.value == 2.5
    end

    test "returns changeset if user tries to rate more then once" do
      user = insert(:user)
      product = insert(:product, status: "IN_LIBRARY")
      assert {:ok, _} = Library.rate(product.id, user.id, 4.5)
      assert {:error, %Ecto.Changeset{}} = Library.rate(product.id, user.id, 2)
      product = Library.get(product.id)
      assert length(product.ratings) == 1
      assert Enum.at(product.ratings, 0).value == 4.5
    end

    test "returns changeset if rating out of range" do
      user = insert(:user)
      product = insert(:product, status: "IN_LIBRARY")
      assert {:error, _} = Library.rate(product.id, user.id, 5.1)
      assert {:error, _} = Library.rate(product.id, user.id, 0.9)
    end

    test "returns changeset if user is not present" do
      product = insert(:product, status: "IN_LIBRARY")
      assert {:error, changeset} = Library.rate(product.id, -1, 4)
      assert {"does not exist", _} = changeset.errors[:user_id]
    end
  end


  describe "subscribe_user_to_return_notification/2" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      user = insert(:user)
      assert Library.subscribe_user_to_return_notification(product.id, user.id) == nil
    end

    test "returns nil if no active product use" do
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user), ended_at: DateTime.utc_now}
      )
      user = insert(:user)
      assert Library.subscribe_user_to_return_notification(product.id, user.id) == nil
    end

    test "returns nil if user already subscibed" do
      user = insert(:user)
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user), return_subscribers: [user.id]}
      )
      assert Library.subscribe_user_to_return_notification(product.id, user.id) == nil
    end

    test "adds user to return_subscribers only once" do
      user = insert(:user)
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user)}
      )
      assert {:ok, _} = Library.subscribe_user_to_return_notification(product.id, user.id)
      product = Library.get(product.id)
      assert product.used_by.return_subscribers == [user.id]
      assert Library.subscribe_user_to_return_notification(product.id, user.id) == nil
    end
  end


  describe "unsubscribe_user_from_return_notification/2" do
    test "returns nil if no such product in library" do
      product = insert(:product)
      user = insert(:user)
      assert Library.unsubscribe_user_from_return_notification(product.id, user.id) == nil
    end

    test "returns nil if no active product use" do
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user), ended_at: DateTime.utc_now}
      )
      user = insert(:user)
      assert Library.unsubscribe_user_from_return_notification(product.id, user.id) == nil
    end

    test "returns nil if user is not subscibed" do
      user = insert(:user)
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user), return_subscribers: []}
      )
      assert Library.unsubscribe_user_from_return_notification(product.id, user.id) == nil
    end

    test "removes user from return_subscribers" do
      user = insert(:user)
      product = insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user), return_subscribers: [user.id]}
      )
      assert {:ok, _} = Library.unsubscribe_user_from_return_notification(product.id, user.id)
      product = Library.get(product.id)
      assert product.used_by.return_subscribers == []
    end
  end
end
