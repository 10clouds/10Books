defmodule LibTen.ProductsTest do
  use LibTen.DataCase

  alias LibTen.Products

  describe "products" do
    alias LibTen.Products.Product

    @valid_attrs %{
      author: "some author",
      status: "REQUESTED",
      title: "some title",
      url: "http://google.com"
    }
    @update_attrs %{
      author: "some updated author",
      status: "ORDERED",
      title: "some updated title",
      url: "http://google.com"
    }
    @invalid_attrs %{author: nil, status: nil, title: nil, url: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.author == "some author"
      assert product.status == "REQUESTED"
      assert product.title == "some title"
      assert product.url == "http://google.com"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Products.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.author == "some updated author"
      assert product.status == "ORDERED"
      assert product.title == "some updated title"
      assert product.url == "http://google.com"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
