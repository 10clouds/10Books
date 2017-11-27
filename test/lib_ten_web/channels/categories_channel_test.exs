defmodule LibTenWeb.CategoriesChannelTest do
  use LibTenWeb.ChannelCase

  import LibTen.Factory

  alias LibTen.Categories
  alias LibTenWeb.CategoriesChannel

  setup do
    user = insert(:user)
    {:ok, socket: socket("user_socket", %{user_id: user.id})}
  end

  test "replies with categories on join", %{socket: socket} do
    categories = insert_pair(:category)
    {:ok, reply, _socket} = subscribe_and_join(socket, CategoriesChannel, "categories")
    assert reply == %{payload: Categories.to_json_map(categories)}
  end
end
