defmodule LibTenWeb.LayoutView do
  use LibTenWeb, :view

  def get_current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end
