defmodule LibTenWeb.Products.AllChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTenWeb.Products.{AllChannel, ChannelHelpers}


  describe "User is not an admin" do
    test "returns error on join" do
      user = insert(:user)
      socket_status =
        socket("user_socket", %{user: user})
        |> join(AllChannel, "products:all")
      assert {:error, %{reason: :unauthorized}} = socket_status
    end
  end


  describe "User is an admin" do
    setup do
      user = insert(:user, is_admin: true)
      insert_pair(:product, status: "ORDERED")
      {:ok, reply, socket} =
        socket("user_socket", %{user: user})
        |> subscribe_and_join(AllChannel, "products:all")
      {:ok, socket_reply: reply, socket: socket, socket_user: user}
    end

    test "returns list of products on join", %{socket_reply: socket_reply} do
      products_json = LibTen.Products.All.list() |> ChannelHelpers.to_json_map
      assert %{payload: ^products_json} = socket_reply
    end


    test "handle_in/update replies with :error if no such record", %{socket: socket} do
      ref = push socket, "update", %{"id" => -1, "attrs" => %{"category_id": 1}}
      reply = assert_reply ref, :error
      assert reply.payload == %{type: "NOT_FOUND"}
    end


    test "handle_in/update replices with :ok if record present", %{socket: socket} do
      product = insert(:product)
      category = insert(:category)
      ref = push socket, "update", %{"id" => product.id, "attrs" => %{"category_id": category.id}}
      assert_reply ref, :ok
      assert LibTen.Products.All.get(product.id).category_id == category.id
    end
  end

end
