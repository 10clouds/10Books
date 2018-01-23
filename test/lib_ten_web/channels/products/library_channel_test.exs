defmodule LibTenWeb.Products.LibraryChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTen.Products.Library
  alias LibTenWeb.Products.{LibraryChannel, ChannelHelpers}

  # TODO: No need to create 2 products for each test
  setup do
    user = insert(:user)
    insert_pair(:product, status: "IN_LIBRARY")
    {:ok, reply, socket} =
      socket("user_socket", %{user: user})
      |> subscribe_and_join(LibraryChannel, "products:library")
    {:ok, socket_reply: reply, socket: socket, socket_user: user}
  end


  test "returns list of products on join", %{socket_reply: socket_reply} do
    products_json = LibTen.Products.Library.list() |> ChannelHelpers.to_json_map
    assert %{payload: ^products_json} = socket_reply
  end


  describe "handle_in/update" do
    test "replies with :error if no such record in library", %{socket: socket} do
      product = insert(:product)
      ref = push socket, "update", %{"id" => product.id, "attrs" => %{"category_id": 1}}
      reply = assert_reply ref, :error
      assert reply.payload == %{type: "NOT_FOUND"}
    end

    test "replices with :ok if record present in library", %{socket: socket} do
      product = insert(:product, status: "IN_LIBRARY")
      category = insert(:category)
      ref = push socket, "update", %{"id" => product.id, "attrs" => %{"category_id": category.id}}
      assert_reply ref, :ok
      assert LibTen.Products.Library.get(product.id).category_id == category.id
    end
  end


  test "handle_in/take", %{socket: socket, socket_user: socket_user} do
    product = insert(:product, status: "IN_LIBRARY")
    ref = push socket, "take", %{"id" => product.id}
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by.user == socket_user
    assert product.used_by.ended_at == nil
  end


  test "handle_in/return", %{socket: socket, socket_user: socket_user} do
    product = insert(:product,
      status: "IN_LIBRARY",
      used_by: %{user: socket_user}
    )
    ref = push socket, "return", %{"id" => product.id}
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by == nil
  end


  test "handle_in/rate", %{socket: socket} do
    product = insert(:product, status: "IN_LIBRARY")
    ref = push socket, "rate", %{"id" => product.id, "value" => 2.5}
    assert_reply ref, :ok
    product = Library.get(product.id)
    rating = Enum.at(product.ratings, 0)
    assert rating.user_id == socket.assigns.user.id
    assert rating.value == 2.5
  end

end
