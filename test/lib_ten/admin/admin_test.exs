defmodule LibTen.AdminTest do
  use LibTen.DataCase
  alias LibTen.Admin
  import LibTen.Factory

  describe "settings" do
    alias LibTen.Admin.Settings

    test "get_settings/1 creates new record if none present" do
      assert Repo.one(Settings) == nil
      assert %Settings{} = Admin.get_settings()
    end

    test "get_settings/1 returns previously created settings" do
      insert(:settings)
      assert %Settings{logo: "test.png"} = Admin.get_settings()
    end

    test "update_settings/2 updates settings" do
      settings = insert(:settings)

      assert {:ok, %Settings{logo: "test2.png"}} =
               Admin.update_settings(settings, %{logo: "test2.png"})
    end
  end
end
