defmodule LibTenWeb.LibraryController do
  use LibTenWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
