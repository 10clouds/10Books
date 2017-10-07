defmodule LibTen.AccountsTest do
  use LibTen.DataCase
  alias LibTen.Accounts

  describe "users" do
    @valid_attrs %{name: "Ruslan Savenok", email: "ruslan@10clouds.com"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
      #  |> Accounts.create_user()

      user
    end

    test "get_user_by_email!/1 returns user with given email or Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError,
        fn -> Accounts.get_user_by_email!(@valid_attrs.email) end
      user = user_fixture()
      assert {:ok, found_user} = Accounts.get_user_by_email!(user.email)
      assert found_user == user
    end
  end
end
