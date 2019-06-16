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
      assert %Settings{logo: %{file_name: _}} = Admin.get_settings()
    end

    test "update_settings/2 updates settings" do
      settings = insert(:settings)
      new_file = %Plug.Upload{path: "test/support/blank.png", filename: "test2.png"}

      {:ok, new_settings} =
        Admin.update_settings(settings, %{
          logo: new_file
        })

      assert new_settings.logo.file_name == new_file.filename
    end
  end
end
