defmodule LibTenWeb.CategoriesChannel do
  use Phoenix.Channel

  alias LibTen.Categories
  alias LibTen.Categories.Category

  def join("categories", _message, socket) do
    categories = Enum.map(Categories.list_categories(), &(Category.to_map(&1)))
    {:ok, %{payload: categories}, socket}
  end
end
