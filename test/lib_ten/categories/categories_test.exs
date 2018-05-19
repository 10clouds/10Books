defmodule LibTen.CategoriesTest do
  use LibTen.DataCase

  import LibTen.Factory

  alias LibTen.Categories

  describe "categories" do
    alias LibTen.Categories.Category

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories with assigned colors" do
      [category1, category2] = insert_pair(:category)
      assert Categories.list_categories() == [category1, category2]
    end

    test "get_category!/1 returns the category with given id" do
      category = insert(:category)
      assert Categories.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      params = params_for(:category)
      assert {:ok, %Category{} = category} = Categories.create_category(params)
      assert category.name == params.name
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = insert(:category)
      assert {:ok, category} = Categories.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = insert(:category)
      assert {:error, %Ecto.Changeset{}} = Categories.update_category(category, @invalid_attrs)
      assert category == Categories.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = Categories.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = insert(:category)
      assert %Ecto.Changeset{} = Categories.change_category(category)
    end
  end
end
