defmodule LibTenWeb.CategoriesChannel do
  use Phoenix.Channel

  alias LibTen.Categories
  alias LibTen.Categories.Category

  def join("categories", _message, socket) do
    categories = Categories.list_categories() |> Categories.to_json_map
    {:ok, %{payload: categories}, socket}
  end
end
