defmodule LibTenWeb.UserSocket do
  use Phoenix.Socket

  channel "products:library", LibTenWeb.Products.LibraryChannel
  channel "products:orders", LibTenWeb.Products.OrdersChannel
  channel "products:all", LibTenWeb.Products.AllChannel
  channel "categories", LibTenWeb.CategoriesChannel

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "current_user_token", token, max_age: 1_209_600) do
      {:ok, user_data} -> {:ok, assign(socket, :user, user_data)}
      error -> error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.user.id}"
end
