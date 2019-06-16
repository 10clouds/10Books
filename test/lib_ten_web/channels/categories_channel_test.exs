defmodule LibTenWeb.CategoriesChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTenWeb.CategoriesChannel

  setup do
    user = insert(:user)
    {:ok, socket: socket(LibTenWeb.UserSocket, "user_socket", %{user_id: user.id})}
  end

  test "replies with categories on join", %{socket: socket} do
    insert_pair(:category)
    {:ok, reply, _socket} = subscribe_and_join(socket, CategoriesChannel, "categories")
    assert %{payload: [%{id: _, name: _}, %{id: _, name: _}]} = reply
  end
end
