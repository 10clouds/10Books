defmodule LibTen.Accounts.UsersTest do
  use LibTen.DataCase

  alias LibTen.Accounts.Users
  alias LibTen.Accounts.User

  @valid_attrs %{name: "Ruslan Savenok", email: "ruslan@10clouds.com"}
  @update_attrs %{name: "Ruslan 2", email: "ruslan-2@10clouds.com"}
  @invalid_attrs %{name: nil, email: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Users.create()
    user
  end

  test "list/0 returns all users" do
    user1 = user_fixture()
    user2 = user_fixture(%{email: "#{@valid_attrs.email}2"})
    assert Users.list() == [user1, user2]
  end

  test "get!/1 returns user with given id" do
    user = user_fixture()
    assert Users.get!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Users.create(@valid_attrs)
    assert user.name == "Ruslan Savenok"
    assert user.email == "ruslan@10clouds.com"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Users.create(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = user_fixture()
    assert {:ok, user} = Users.update(user, @update_attrs)
    assert %User{} = user
    assert user.name == "Ruslan 2"
    assert user.email == "ruslan-2@10clouds.com"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = user_fixture()
    assert {:error, %Ecto.Changeset{}} = Users.update(user, @invalid_attrs)
    assert user == Users.get!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = user_fixture()
    assert {:ok, %User{}} = Users.delete(user)
    assert_raise Ecto.NoResultsError, fn -> Users.get!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = user_fixture()
    assert %Ecto.Changeset{} = Users.change(user)
  end
end
