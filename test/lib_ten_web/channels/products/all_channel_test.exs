defmodule LibTenWeb.Products.AllChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTen.Products.All
  alias LibTenWeb.Products.AllChannel

  describe "User is not an admin" do
    test "returns error on join" do
      user = insert(:user)

      socket_status =
        socket(LibTenWeb.UserSocket, "user_socket", %{user: user})
        |> join(AllChannel, "products:all")

      assert {:error, %{reason: :unauthorized}} = socket_status
    end
  end

  describe "User is an admin" do
    setup do
      user = insert(:user, is_admin: true)
      insert_pair(:product, status: "ORDERED")

      {:ok, reply, socket} =
        socket(LibTenWeb.UserSocket, "user_socket", %{user: user})
        |> subscribe_and_join(AllChannel, "products:all")

      {:ok, socket_reply: reply, socket: socket, socket_user: user}
    end

    test "returns list of products on join", %{socket_reply: socket_reply} do
      # TODO: json schema
      products_json =
        LibTenWeb.ProductsView.render("index.json",
          products: All.list()
        )

      assert %{payload: ^products_json} = socket_reply
    end

    test "handle_in/create creates a record", %{socket: socket} do
      category = insert(:category)

      attrs =
        string_params_for(:product,
          category_id: category.id,
          status: "IN_LIBRARY"
        )

      ref = push(socket, "create", %{"attrs" => attrs})
      reply = assert_reply ref, :ok
      product = All.get(reply.payload.id)
      assert product.requested_by_user_id == socket.assigns.user.id
      assert product.category_id == attrs["category_id"]
      assert product.author == attrs["author"]
      assert product.title == attrs["title"]
      assert product.url == attrs["url"]
      assert product.status == attrs["status"]
    end

    test "handle_in/force_return removes used_by from a product", %{socket: socket} do
      product = insert(:product)
      user = insert(:user)

      product_use =
        insert(:product_use,
          product_id: product.id,
          user_id: user.id
        )

      assert All.get(product.id).used_by.id == product_use.id
      ref = push(socket, "force_return", %{"id" => product.id})
      assert_reply ref, :ok
      assert All.get(product.id).used_by == nil
    end

    test "handle_in/update replies with :error if no such record", %{socket: socket} do
      ref = push(socket, "update", %{"id" => -1, "attrs" => %{category_id: 1}})
      reply = assert_reply ref, :error
      assert reply.payload == %{type: "NOT_FOUND"}
    end

    test "handle_in/update replices with :ok if record present", %{socket: socket} do
      product = insert(:product, status: "IN_LIBRARY")
      category = insert(:category)
      ref = push(socket, "update", %{"id" => product.id, "attrs" => %{category_id: category.id}})
      assert_reply ref, :ok
      assert All.get(product.id).category_id == category.id
    end
  end
end
