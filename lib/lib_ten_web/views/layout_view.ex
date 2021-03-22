defmodule LibTenWeb.LayoutView do
  use LibTenWeb, :view

  def admin_section?(conn) do
    String.starts_with?(Phoenix.Controller.current_path(conn), "/admin/")
  end
end
