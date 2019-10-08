defmodule LibTen.AccountsTest do
  use LibTen.DataCase
  import LibTen.Factory
  alias LibTen.Accounts

  test "list_users/1 returns only users with passed ids" do
    [user1, user2, _] = insert_list(3, :user)
    assert Accounts.list_users([user2.id, user1.id]) == [user1, user2]
  end

  test "get_b!/1 returns user with given email or nil" do
    assert Accounts.get_by(%{email: params_for(:user)[:email]}) == nil
    user = insert(:user)
    assert user == Accounts.get_by(%{email: user.email})
  end

  describe "accounts -> find_or_create_user/1" do
    test "returns an error if email is not in allowed_google_auth_domains" do
      user = %{email: "test@invalid.com", name: "Test user"}
      {:error, msg} = Accounts.find_or_create_user(user)
      assert msg =~ "Only accounts with"
    end

    test "creates user if it is not present" do
      assert Accounts.get_by(%{email: "test@test.com"}) == nil
      user_params = params_for(:user)
      assert {:ok, user} = Accounts.find_or_create_user(user_params)
      assert user.email == user_params.email
      assert user.name == user_params.name
    end

    test "updates user info if user present" do
      user = insert(:user)

      new_params = %{
        google_uid: user.google_uid,
        email: "new" <> user.email,
        name: user.name <> "new",
        avatar_url: user.avatar_url <> "new"
      }

      assert {:ok, updated_user} = Accounts.find_or_create_user(new_params)
      assert updated_user.id == user.id
      assert updated_user.google_uid == new_params.google_uid
      assert updated_user.email == new_params.email
      assert updated_user.name == new_params.name
      assert updated_user.avatar_url == new_params.avatar_url
    end

    test "returns exising user if it is present" do
      exising_user_params = params_for(:user)
      exising_user = insert(:user, exising_user_params)
      assert {:ok, user} = Accounts.find_or_create_user(exising_user_params)
      assert user == exising_user
    end

    test "finds and updates legacy google user" do
      user_params = params_for(:user)
      user = insert(:user, Map.merge(user_params, %{google_uid: nil}))
      assert user.google_uid == nil

      {:ok, updated_user} = Accounts.find_or_create_user(user_params)
      assert updated_user.id == user.id
      assert updated_user.email == user.email
      assert updated_user.google_uid == user_params.google_uid
    end
  end
end
