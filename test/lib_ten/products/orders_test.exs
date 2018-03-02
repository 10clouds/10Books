defmodule LibTen.Products.OrdersTest do
  use LibTen.DataCase
  import LibTen.Factory
  alias LibTen.Products.Orders

  test "list/0 returns only products with order status sorted by inserted_at" do
    user = insert(:user)
    product1 = insert(:product,
      status: "ORDERED",
      inserted_at: ~N[2000-01-01 00:00:00.000000],
      requested_by_user: user,
      votes: [%{user: user, is_upvote: true}]
    )
    product2 = insert(:product,
      status: "ORDERED",
      inserted_at: ~N[2000-01-01 00:01:00.000000],
      requested_by_user: user,
      votes: [%{user: user, is_upvote: true}]
    )
    insert(:product)
    assert Orders.list() == [product2, product1]
  end


  test "get/1 returns product if it has order status" do
    user = insert(:user)
    product1 = insert(:product,
      status: "ORDERED",
      requested_by_user: user,
      votes: []
    )
    product2 = insert(:product)
    assert Orders.get(product1.id) == product1
    assert Orders.get(product2.id) == nil
  end


  test "create/2 creates record with REQUESTED status" do
    user = insert(:user)
    category = insert(:category)
    attrs = params_for(:product, category_id: category.id)
    {:ok, product} = Orders.create(attrs, user.id)
    assert product.requested_by_user_id == user.id
    assert product.author == attrs.author
    assert product.title == attrs.title
    assert product.url == attrs.url
    assert product.status == "REQUESTED"
  end


  describe "update/4" do
    test "returns nil in no order with given id" do
      user = insert(:user)
      product = insert(:product)
      assert Orders.update(product.id, %{category_id: 1}, "user", user.id) == nil
    end

    test "returns %Ecto.Changeset{} if record is invalid" do
      user = insert(:user)
      product = insert(:product, status: "ORDERED", category: insert(:category))
      attrs = %{url: ''}
      {:error, %Ecto.Changeset{}} = Orders.update(product.id, attrs, "user", user.id)
    end

    test "with user role, updates order if it's present" do
      user = insert(:user)
      product = insert(:product, status: "ORDERED")
      category = insert(:category)
      attrs = params_for(:product, category_id: category.id)
      {:ok, updated_product} = Orders.update(product.id, attrs, "user", user.id)
      assert updated_product.author == attrs.author
      assert updated_product.title == attrs.title
      assert updated_product.url == attrs.url
      assert updated_product.category_id == category.id
    end

    test "with user role, will update status to DELETED if it's a user order" do
      user = insert(:user)
      category = insert(:category)
      product = insert(:product, status: "ORDERED", category: category)
      product2 = insert(:product,
        status: "ORDERED",
        requested_by_user_id: user.id,
        category: category
      )

      {:ok, updated_product} = Orders.update(product.id, %{"status" => "REQUESTED"}, "user", user.id)
      assert updated_product.status == "ORDERED"
      {:ok, updated_product} = Orders.update(product2.id, %{"status" => "REQUESTED"}, "user", user.id)
      assert updated_product.status == "ORDERED"
      {:ok, updated_product} = Orders.update(product2.id, %{"status" => "DELETED"}, "user", user.id)
      assert updated_product.status == "DELETED"
    end

    test "with admin role, updates order if it's present" do
      user = insert(:user)
      product = insert(:product, status: "ORDERED")
      category = insert(:category)
      attrs = params_for(:product, category_id: category.id, status: "ACCEPTED")
      {:ok, updated_product} = Orders.update(product.id, attrs, "admin", user.id)
      assert updated_product.author == attrs.author
      assert updated_product.title == attrs.title
      assert updated_product.url == attrs.url
      assert updated_product.category_id == category.id
      assert updated_product.status == "ACCEPTED"
    end
  end


  describe "votes" do
    test "returns nil if order doesnt exist" do
      product = insert(:product)
      user = insert(:user)
      assert Orders.upvote(product.id, user.id) == nil
      assert Orders.downvote(product.id, user.id) == nil
    end

    test "insert or updates user vote" do
      user1 = insert(:user)
      user2 = insert(:user)
      product1 = insert(:product, status: "ORDERED")
      product2 = insert(:product, status: "ORDERED")
      {:ok, _} = Orders.upvote(product1.id, user1.id)
      {:ok, _} = Orders.downvote(product1.id, user2.id)
      {:ok, _} = Orders.upvote(product2.id, user1.id)
      {:ok, _} = Orders.upvote(product2.id, user2.id)
      {:ok, _} = Orders.upvote(product1.id, user2.id)
      product1 = Orders.get(product1.id)
      product2 = Orders.get(product2.id)
      assert Enum.at(product1.votes, 0).user_id == user1.id
      assert Enum.at(product1.votes, 0).is_upvote == true
      assert Enum.at(product1.votes, 1).user_id == user2.id
      assert Enum.at(product1.votes, 1).is_upvote == true

      assert Enum.at(product2.votes, 0).user_id == user1.id
      assert Enum.at(product2.votes, 0).is_upvote == true
      assert Enum.at(product2.votes, 1).user_id == user2.id
      assert Enum.at(product2.votes, 1).is_upvote == true
    end
  end
end
