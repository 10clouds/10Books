defmodule LibTen.ProductsTest do
  use LibTen.DataCase

  import LibTen.Factory
  import Mock

  alias LibTen.Products
  alias LibTen.Products.Product

  @update_attrs %{
    author: "some updated author",
    status: "ORDERED",
    title: "some updated title",
    url: "http://google.com"
  }
  @invalid_attrs %{author: nil, status: nil, title: nil, url: nil}

  setup do
    user = insert(:user)
    {:ok, socket: socket("user_socket", %{user_id: user.id})}
  end

  test "list_products/0 returns all products" do
    product1 = insert(:product)
    product2 = insert(:product)
    product3 = insert(:product)
    user1 = insert(:user)
    user2 = insert(:user)
    product_use1 = insert(:product_use, product_id: product1.id, user_id: user1.id)
    product_use2 = insert(:product_use, product_id: product2.id, user_id: user2.id)
    insert(:product_use, product_id: product3.id, user_id: user1.id, ended_at: DateTime.utc_now)

    products = Products.list_products()
    expected_product1 = Map.merge(product1, %{
      product_use: Map.merge(product_use1, %{user: user1})
    })
    expected_product2 = Map.merge(product2, %{
      product_use: Map.merge(product_use2, %{user: user2})
    })
    expected_product3 =  Map.merge(product3, %{product_use: nil})

    assert Enum.at(products, 0) == expected_product1
    assert Enum.at(products, 1) == expected_product2
    assert Enum.at(products, 2) == expected_product3
  end

  test "get_product!/1 returns the product with given id" do
    product = insert(:product)
    user = insert(:user)
    product_use = insert(:product_use, product_id: product.id, user_id: user.id)
    assert Products.get_product!(product.id) == Map.merge(product, %{
      product_use: Map.merge(product_use, %{user: user})
    })
  end

  test "create_product/1 with valid data creates a product and notifies channel" do
    LibTenWeb.Endpoint.subscribe("products")
    product_attrs = params_for(:product)
    assert {:ok, %Product{} = product} = Products.create_product(product_attrs)
    assert product.author == product_attrs.author
    assert product.status == product_attrs.status
    assert product.title == product_attrs.title
    assert product.url == product_attrs.url

    product_json = Products.to_json_map(product)
    assert_broadcast "created", ^product_json
  end

  test "create_product/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
  end

  test "update_product/2 with valid data updates the product and notifies channel" do
    LibTenWeb.Endpoint.subscribe("products")
    product = insert(:product)
    assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
    assert product.author == @update_attrs.author
    assert product.status == @update_attrs.status
    assert product.title == @update_attrs.title
    assert product.url == @update_attrs.url

    product_json = Products.to_json_map(product)
    assert_broadcast "updated", ^product_json
  end

  test "update_product/2 with invalid data returns error changeset" do
    product = insert(:product, product_use: nil)
    assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
    assert product == Products.get_product!(product.id)
  end

  test "delete_product/1 deletes the product and notifies channel" do
    LibTenWeb.Endpoint.subscribe("products")
    product = insert(:product)
    assert {:ok, %Product{} = product} = Products.delete_product(product)
    product_json = Products.to_json_map(product)
    assert_broadcast "deleted", ^product_json
    assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
  end

  test "change_product/1 returns a product changeset" do
    product = insert(:product)
    assert %Ecto.Changeset{} = Products.change_product(product)
  end

  describe "take_product/2" do
    test "creates new record and notifies channel unless same product_id & ended_at=nil present" do
      LibTenWeb.Endpoint.subscribe("products")
      user = insert(:user)
      product = insert(:product, product_use: nil)
      assert {:ok, %Product{} = product} = Products.take_product(product.id, user.id)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json
      assert product.product_use.product_id == product.id
      assert product.product_use.user_id == user.id
      assert product.product_use.ended_at == nil
      assert {:error, %Ecto.Changeset{}} = Products.take_product(product.id, user.id)
      refute_broadcast "updated", ^product_json
    end
  end

  describe "return_product/2" do
    test "updates existing product ended_at if it's present and notifies channel" do
      LibTenWeb.Endpoint.subscribe("products")
      date_now = DateTime.utc_now
      naive_date_now = DateTime.to_naive(date_now)
      user = insert(:user)
      product = insert(:product)
      Products.take_product(product.id, user.id)
      with_mock DateTime, [utc_now: fn -> date_now end] do
        assert {:ok, %Product{} = product} = Products.return_product(product.id, user.id)
        product_json = Products.to_json_map(product)
        assert_broadcast "updated", ^product_json
        assert naive_date_now == product.product_use.ended_at
      end
    end
  end

  test "can take_product/2 if it was taken and then returned" do
    user = insert(:user)
    user2 = insert(:user)
    product = insert(:product)
    Products.take_product(product.id, user.id)
    assert {:error, _} = Products.take_product(product.id, user2.id)
    Products.return_product(product.id, user.id)
    assert {:ok, _} = Products.take_product(product.id, user2.id)
  end

  describe "rate product" do
    test "rate_product/3 updates average rating and notifies channel" do
      LibTenWeb.Endpoint.subscribe("products")
      user = insert(:user)
      user2 = insert(:user)
      product = insert(:product)
      product = Products.get_product!(product.id)
      assert product.rating == nil
      {:ok, product} = Products.rate_product(product.id, user.id, 4.5)
      assert product.rating == 4.5
      {:ok, product} = Products.rate_product(product.id, user2.id, 2.5)
      assert product.rating == 3.5
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json
    end

    test "rate_product/3 returns an error if user tries to rate more then once" do
      user = insert(:user)
      product = insert(:product)
      assert {:ok, _} = Products.rate_product(product.id, user.id, 4.5)
      assert {:error, %Ecto.Changeset{}} = Products.rate_product(product.id, user.id, 2)
      product = Products.get_product!(product.id)
      assert product.rating == 4.5
    end
  end
end
