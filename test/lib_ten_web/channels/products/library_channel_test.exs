defmodule LibTenWeb.Products.LibraryChannelTest do
  use LibTenWeb.ChannelCase
  import LibTen.Factory
  alias LibTen.Products.Library
  alias LibTenWeb.Products.LibraryChannel

  setup do
    user = insert(:user)
    socket = socket(LibTenWeb.UserSocket, "user_socket", %{user: user})
    {:ok, socket: socket}
  end

  test "returns list of products on join", %{socket: socket} do
    p1 = insert(:product, status: "IN_LIBRARY", inserted_at: ~N[2000-01-01 09:00:00])
    p2 = insert(:product, status: "IN_LIBRARY")
    {:ok, reply, _} = join(socket, LibraryChannel, "products:library")
    # TODO: json schema
    p1_json = LibTenWeb.ProductsView.render("show.json", product: p1)
    p2_json = LibTenWeb.ProductsView.render("show.json", product: p2)
    assert %{payload: [^p2_json, ^p1_json]} = reply
  end

  describe "handle_in/update" do
    test "replies with :error if no such record in library", %{socket: socket} do
      {:ok, _, socket} = join(socket, LibraryChannel, "products:library")
      product = insert(:product)
      ref = push(socket, "update", %{"id" => product.id, "attrs" => %{category_id: 1}})
      reply = assert_reply ref, :error
      assert reply.payload == %{type: "NOT_FOUND"}
    end

    test "replices with :ok if record present in library", %{socket: socket} do
      {:ok, _, socket} = join(socket, LibraryChannel, "products:library")
      product = insert(:product, status: "IN_LIBRARY")
      category = insert(:category)
      ref = push(socket, "update", %{"id" => product.id, "attrs" => %{category_id: category.id}})
      assert_reply ref, :ok
      assert LibTen.Products.Library.get(product.id).category_id == category.id
    end
  end

  test "handle_in/take", %{socket: socket} do
    {:ok, _, socket} = join(socket, LibraryChannel, "products:library")
    product = insert(:product, status: "IN_LIBRARY")
    ref = push(socket, "take", %{"id" => product.id})
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by.user == socket.assigns.user
    assert product.used_by.ended_at == nil
  end

  test "handle_in/return", %{socket: socket} do
    {:ok, _, socket} = join(socket, LibraryChannel, "products:library")

    product =
      insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: socket.assigns.user}
      )

    ref = push(socket, "return", %{"id" => product.id})
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by == nil
  end

  test "handle_in/rate", %{socket: socket} do
    {:ok, _, socket} = join(socket, LibraryChannel, "products:library")
    product = insert(:product, status: "IN_LIBRARY")
    ref = push(socket, "rate", %{"id" => product.id, "value" => 2.5})
    assert_reply ref, :ok
    product = Library.get(product.id)
    rating = Enum.at(product.ratings, 0)
    assert rating.user_id == socket.assigns.user.id
    assert rating.value == 2.5
  end

  test "handle_in/subscribe_to_return_notification", %{socket: socket} do
    {:ok, _, socket} = join(socket, LibraryChannel, "products:library")

    product =
      insert(:product,
        status: "IN_LIBRARY",
        used_by: %{user: insert(:user)}
      )

    ref = push(socket, "subscribe_to_return_notification", %{"id" => product.id})
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by.return_subscribers == [socket.assigns.user.id]
  end

  test "handle_in/unsubscribe_from_return_notification", %{socket: socket} do
    {:ok, _, socket} = join(socket, LibraryChannel, "products:library")

    product =
      insert(:product,
        status: "IN_LIBRARY",
        used_by: %{
          user: insert(:user),
          return_subscribers: [socket.assigns.user.id]
        }
      )

    ref = push(socket, "unsubscribe_from_return_notification", %{"id" => product.id})
    assert_reply ref, :ok
    product = Library.get(product.id)
    assert product.used_by.return_subscribers == []
  end
end
