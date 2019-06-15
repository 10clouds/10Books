defmodule LibTen.AccountsTest do
  use LibTen.DataCase
  import LibTen.Factory
  alias LibTen.Accounts

  test "list_users/1 returns only users with passed ids" do
    [user1, user2, _] = insert_list(3, :user)
    assert Accounts.list_users([user2.id, user1.id]) == [user1, user2]
  end

  test "get_by!/1 returns user with given email or Ecto.NoResultsError" do
    assert_raise Ecto.NoResultsError,
                 fn -> Accounts.get_by!(%{email: params_for(:user)[:email]}) end

    user = insert(:user)
    assert user == Accounts.get_by!(%{email: user.email})
  end

  describe "accounts -> find_or_create_user/1" do
    test "returns an error if email is not in allowed_google_auth_domains" do
      user = %{email: "test@invalid.com", name: "Test user"}
      {:error, msg} = Accounts.find_or_create_user(user)
      assert msg =~ "Only accounts with"
    end

    test "creates user if it is not present" do
      assert_raise Ecto.NoResultsError,
                   fn -> Accounts.get_by!(%{email: "test@test.com"}) end

      user_params = params_for(:user)
      assert {:ok, user} = Accounts.find_or_create_user(user_params)
      assert user.email == user_params.email
      assert user.name == user_params.name
    end

    test "returns exising user if it is present" do
      exising_user_params = params_for(:user)
      exising_user = insert(:user, exising_user_params)
      assert {:ok, user} = Accounts.find_or_create_user(exising_user_params)
      assert user == exising_user
    end
  end
end
