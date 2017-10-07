defmodule LibTen.AccountsTest do
  use LibTen.DataCase
  alias LibTen.Accounts

  describe "users" do
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
  end
end
