defmodule LibTen.ProductsTest do
  use LibTen.DataCase

  import LibTen.Factory
  import Mock

  alias LibTen.Products
  alias LibTen.Products.{Product, ProductUse}

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

  test "to_json_map/1 build valid JSON" do
    user = insert(:user)
    user2 = insert(:user)
    product = insert(:product,
      product_use: %{
        user: user
      },
      product_votes: [
        %{
          user: user,
          is_upvote: true
        },
        %{
          user: user2,
          is_upvote: false
        },
      ],
      product_ratings: [
        %{
          user: user,
          value: 4
        },
        %{
          user: user2,
          value: 5
        },
      ]
    )

    json = Products.to_json_map(product)
    expected_votes = [
      %{is_upvote: true, user: %{id: user.id, name: user.name}},
      %{is_upvote: false, user: %{id: user2.id, name: user2.name}}
    ]
    expected_ratings = [
      %{value: 4, user: %{id: user.id, name: user.name}},
      %{value: 5, user: %{id: user2.id, name: user2.name}}
    ]

    assert json.id == product.id
    assert json.title == product.title
    assert json.url == product.url
    assert json.author == product.author
    assert json.status == product.status
    assert json.category_id == product.category_id
    assert json.in_use.started_at == product.product_use.inserted_at
    assert json.votes == expected_votes
    assert json.ratings == expected_ratings
    assert json.in_use.user_name == user.name
  end

  test "list_products/0 returns all products except deleted" do
    user1 = insert(:user)
    user2 = insert(:user)
    product1 = insert(:product,
      product_use: %{
        user: user1
      },
      product_votes: [
        %{
          user: user1,
          is_upvote: true
        }
      ],
      product_ratings: [
        %{
          user: user1,
          value: 5
        }
      ]
    )
    product2 = insert(:product,
      product_use: %{
        user: user2
      },
      product_votes: [
        %{
          user: user2,
          is_upvote: true
        }
      ],
      product_ratings: [
        %{
          user: user2,
          value: 5
        }
      ]
    )
    product3 = insert(:product, product_use: nil, product_votes: [], product_ratings: [])
    insert(:product, deleted: true)
    products = Products.list_products()
    assert Enum.at(products, 0) == product3
    assert Enum.at(products, 1) == product2
    assert Enum.at(products, 2) == product1
  end

  test "get_product!/1 returns the product with given id" do
    user = insert(:user)
    inserted_product = insert(:product,
      product_use: %{
        user: user
      },
      product_votes: [
        %{
          user: user,
          is_upvote: true
        }
      ],
      product_ratings: [
        %{
          user: user,
          value: 5
        }
      ]
    )
    product = Products.get_product!(inserted_product.id)
    assert product == inserted_product
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
    product = insert(:product, product_use: nil, product_votes: [], product_ratings: [])
    assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
    assert product == Products.get_product!(product.id)
  end

  test "delete_product/1 marks product as deleted and notifies channel" do
    LibTenWeb.Endpoint.subscribe("products")
    product = insert(:product)
    assert {:ok, product} = Products.delete_product(product)
    product_json = Products.to_json_map(product)
    assert_broadcast "deleted", ^product_json
    assert product.deleted == true
    assert Repo.get_by(Product, deleted: true, id: product.id)
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
        product_use = Repo.get_by(ProductUse, %{product_id: product.id})
        product_json = Products.to_json_map(product)
        assert_broadcast "updated", ^product_json
        assert naive_date_now == product_use.ended_at
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
    test "rate_product/3 adds user rating and notifies channel" do
      LibTenWeb.Endpoint.subscribe("products")
      user = insert(:user)
      user2 = insert(:user)
      product = insert(:product)

      {:ok, product} = Products.rate_product(product.id, user.id, 4.5)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json

      {:ok, product} = Products.rate_product(product.id, user2.id, 2.5)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json

      rating0 = Enum.at(product.product_ratings, 0)
      rating1 = Enum.at(product.product_ratings, 1)
      assert rating0.user_id == user.id
      assert rating0.value == 4.5
      assert rating1.user_id == user2.id
      assert rating1.value == 2.5
    end

    test "rate_product/3 returns an error if user tries to rate more then once" do
      user = insert(:user)
      product = insert(:product)
      assert {:ok, _} = Products.rate_product(product.id, user.id, 4.5)
      assert {:error, %Ecto.Changeset{}} = Products.rate_product(product.id, user.id, 2)
      product = Products.get_product!(product.id)
      assert Enum.at(product.product_ratings, 0).value == 4.5
    end

    test "rate_product/3 returns changeset if rating out of range" do
      user = insert(:user)
      product = insert(:product)
      assert {:error, _} = Products.rate_product(product.id, user.id, 5.1)
      assert {:error, _} = Products.rate_product(product.id, user.id, 0.9)
    end

    test "rate_product/3 returns changeset if product/user is not present" do
      user = insert(:user)
      product = insert(:product)
      assert {:error, changeset} = Products.rate_product(-1, user.id, 4)
      assert {"does not exist", _} = changeset.errors[:product_id]
      assert {:error, changeset} = Products.rate_product(product.id, -1, 4)
      assert {"does not exist", _} = changeset.errors[:user_id]
    end
  end

  describe "vote for product" do
    test "vote_for_product/3 sets user vote, updates product totals and updates channel" do
      LibTenWeb.Endpoint.subscribe("products")
      user = insert(:user)
      user2 = insert(:user)
      user3 = insert(:user)
      product = insert(:product)

      assert {:ok, product} = Products.vote_for_product(product.id, user.id, true)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json

      assert {:ok, product} = Products.vote_for_product(product.id, user2.id, true)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json

      assert {:ok, product} = Products.vote_for_product(product.id, user3.id, false)
      product_json = Products.to_json_map(product)
      assert_broadcast "updated", ^product_json

      vote0 = Enum.at(product.product_votes, 0)
      vote1 = Enum.at(product.product_votes, 1)
      vote2 = Enum.at(product.product_votes, 2)
      assert vote0.user_id == user.id
      assert vote0.is_upvote == true
      assert vote1.user_id == user2.id
      assert vote1.is_upvote == true
      assert vote2.user_id == user3.id
      assert vote2.is_upvote == false
    end

    test "vote_for_product/3 returns :error if product/user doesnt exist" do
      user = insert(:user)
      product = insert(:product)
      assert {:error, changeset} = Products.vote_for_product(-1, user.id, true)
      assert {"does not exist", _} = changeset.errors[:product_id]
      assert {:error, changeset} = Products.vote_for_product(product.id, -1, true)
      assert {"does not exist", _} = changeset.errors[:user_id]
    end
  end
end
