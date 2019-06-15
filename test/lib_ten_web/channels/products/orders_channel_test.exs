defmodule LibTenWeb.Products.OrdersChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTen.Products.Orders
  alias LibTenWeb.Products.OrdersChannel

  setup do
    user = insert(:user, is_admin: true)
    insert_pair(:product, status: "ORDERED")

    {:ok, reply, socket} =
      socket("user_socket", %{user: user})
      |> subscribe_and_join(OrdersChannel, "products:orders")

    {:ok, socket_reply: reply, socket: socket, socket_user: user}
  end

  test "returns list of orders on join", %{socket_reply: socket_reply} do
    # TODO: json schema
    products_json =
      LibTenWeb.ProductsView.render("index.json",
        products: Orders.list()
      )

    assert %{payload: ^products_json} = socket_reply
  end

  describe "handle_in/update" do
    test "replies with :error if no such record in orders", %{socket: socket} do
      product = insert(:product)
      ref = push(socket, "update", %{"id" => product.id, "attrs" => %{category_id: 1}})
      reply = assert_reply ref, :error
      assert reply.payload == %{type: "NOT_FOUND"}
    end

    test "replices with :ok if record present in orders", %{socket: socket} do
      product = insert(:product, status: "ORDERED")
      category = insert(:category)
      ref = push(socket, "update", %{"id" => product.id, "attrs" => %{category_id: category.id}})
      assert_reply ref, :ok
      assert Orders.get(product.id).category_id == category.id
    end
  end

  test "handle_in/create creates record with REQUESTED status", %{
    socket: socket,
    socket_user: socket_user
  } do
    category = insert(:category)
    attrs = params_for(:product, category_id: category.id)
    ref = push(socket, "create", %{"attrs" => attrs})
    reply = assert_reply ref, :ok
    product = Orders.get(reply.payload.id)
    assert product.requested_by_user_id == socket_user.id
    assert product.author == attrs.author
    assert product.title == attrs.title
    assert product.url == attrs.url
    assert product.status == "REQUESTED"
  end

  test "handle_in/upvote", %{socket: socket, socket_user: socket_user} do
    product = insert(:product, status: "ORDERED")
    ref = push(socket, "upvote", %{"id" => product.id})
    assert_reply ref, :ok
    product = Orders.get(product.id)
    assert Enum.at(product.votes, 0).user_id == socket_user.id
    assert Enum.at(product.votes, 0).is_upvote == true
  end

  test "handle_in/downvote", %{socket: socket, socket_user: socket_user} do
    product = insert(:product, status: "ORDERED")
    ref = push(socket, "downvote", %{"id" => product.id})
    assert_reply ref, :ok
    product = Orders.get(product.id)
    assert Enum.at(product.votes, 0).user_id == socket_user.id
    assert Enum.at(product.votes, 0).is_upvote == false
  end
end
