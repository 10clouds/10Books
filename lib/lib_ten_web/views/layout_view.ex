defmodule LibTenWeb.LayoutView do
  use LibTenWeb, :view

  def signed_in?(conn) do
    Plug.Conn.get_session(conn, :user_id)
  end
end
