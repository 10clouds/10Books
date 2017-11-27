defmodule LibTenWeb.ProductsChannelTest do
  use LibTenWeb.ChannelCase

  import LibTen.Factory

  alias LibTen.Repo
  alias LibTen.Products
  alias LibTen.Products.Product
  alias LibTenWeb.ProductsChannel

  setup do
    user = insert(:user)
    insert_pair(:product)
    {:ok, reply, socket} =
      socket("user_socket", %{user_id: user.id})
      |> subscribe_and_join(ProductsChannel, "products")
    {:ok, socket_reply: reply, socket: socket}
  end

  test "replies with products on join", %{socket_reply: socket_reply} do
    payload =
      Products.list_products()
      |> Products.to_json_map
    assert socket_reply == %{payload: payload}
  end

  describe "create" do
    test "replies with product if attrs are valid", %{socket: socket} do
      product_params = params_for(:product)
      ref = push socket, "create", %{"attrs" => product_params}
      reply = assert_reply ref, :ok
      product = Repo.get_by!(Product, title: product_params.title)
      assert reply.payload == Products.to_json_map(product)
    end

    test "replies with error if attrs are not valid", %{socket: socket} do
      ref = push socket, "create", %{"attrs" => %{title: "test"}}
      assert_reply ref, :error, %{type: "RECORD_INVALID", errors: _}
    end
  end

  describe "update" do
    test "replies with product if attrs are valid", %{socket: socket} do
      product = insert(:product)
      ref = push socket, "update", %{"id" => product.id, "attrs" => %{"title" => "test"}}
      reply = assert_reply ref, :ok
      updated_product = Repo.get!(Product, product.id)
      assert updated_product.title == "test"
      assert reply.payload == Products.to_json_map(updated_product)
    end

    test "replies with error if attrs are not valid", %{socket: socket} do
      product = insert(:product)
      ref = push socket, "update", %{"id" => product.id, "attrs" => %{"title" => ""}}
      assert_reply ref, :error, %{type: "RECORD_INVALID", errors: _}
    end

    test "replies with error if id is not present", %{socket: socket} do
      ref = push socket, "update", %{"id" => -1, "attrs" => %{"title" => "test"}}
      assert_reply ref, :error, %{type: "NOT_FOUND"}
    end
  end

  describe "delete" do
    test "replies with product if id valid", %{socket: socket} do
      product = insert(:product)
      ref = push socket, "delete", %{"id" => product.id}
      reply = assert_reply ref, :ok
      assert reply.payload == Products.to_json_map(product)
    end

    test "replies with error if id is not present", %{socket: socket} do
      ref = push socket, "delete", %{"id" => -1}
      assert_reply ref, :error, %{type: "NOT_FOUND"}
    end
  end
end
