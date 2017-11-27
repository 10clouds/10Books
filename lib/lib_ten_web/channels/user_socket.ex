defmodule LibTenWeb.UserSocket do
  use Phoenix.Socket

  channel "products", LibTenWeb.ProductsChannel
  channel "categories", LibTenWeb.CategoriesChannel
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "current_user_token", token, max_age: 1209600) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      error -> error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
