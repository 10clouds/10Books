defmodule LibTen.Products.AllTest do
  use LibTen.DataCase
  import LibTen.Factory
  alias LibTen.Products.All

  test "list/0 returns products sorted by inserted_at" do
    product1 = insert(:product, inserted_at: ~N[2000-01-01 00:00:00.000000])
    product2 = insert(:product, inserted_at: ~N[2000-01-01 00:01:00.000000])
    assert All.list() == [product2, product1]
  end

  test "get/1 returns product" do
    product = insert(:product)
    assert All.get(product.id) == product
  end


  describe "update" do
    test "update/3 returns nil in no product with given id" do
      assert All.update(-1, %{category_id: 1}) == nil
    end

    test "update/3 returns %Ecto.Changeset{} if record is invalid" do
      product = insert(:product, status: "ORDERED", category: insert(:category))
      {:error, %Ecto.Changeset{}} = All.update(product.id, %{url: ''})
    end

    test "with user role, update/3 updates product if it's present" do
      product = insert(:product)
      category = insert(:category)
      attrs = params_for(:product, category_id: category.id, status: "ORDERED")
      {:ok, updated_product} = All.update(product.id, attrs)
      assert updated_product.author == attrs.author
      assert updated_product.title == attrs.title
      assert updated_product.url == attrs.url
      assert updated_product.category_id == category.id
      assert updated_product.status == "ORDERED"
    end
  end
end
