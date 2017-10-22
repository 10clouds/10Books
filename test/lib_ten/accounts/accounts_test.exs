defmodule LibTen.AccountsTest do
  use LibTen.DataCase
  alias LibTen.Accounts

  @valid_attrs %{name: "Ruslan Savenok", email: "ruslan@10clouds.com"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()
    user
  end

  test "get_by!/1 returns user with given email or Ecto.NoResultsError" do
    assert_raise Ecto.NoResultsError,
      fn -> Accounts.get_by!(%{email: @valid_attrs.email}) end
    user = user_fixture()
    assert user == Accounts.get_by!(%{email: user.email})
  end

  describe "accounts -> find_or_create_user/1" do
    test "returns an error if email is not @10clouds.com" do
      user = %{email: "test@test.com"}
      assert {:error, :invalid_email_domain} = Accounts.find_or_create_user(user)
    end

    test "creates user if it is not present" do
      assert_raise Ecto.NoResultsError,
        fn -> Accounts.get_by!(%{email: @valid_attrs.email}) end
      assert {:ok, user} = Accounts.find_or_create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.name == @valid_attrs.name
    end

    test "returns exising user if it is present" do
      exising_user = user_fixture(%{email: "exising-user@10clouds.com"})
      assert {:ok, user} = Accounts.find_or_create_user(exising_user)
      assert user == exising_user
    end
  end
end
