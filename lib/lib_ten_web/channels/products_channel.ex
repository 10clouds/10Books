defmodule LibTenWeb.ProductsChannel do
  use Phoenix.Channel

  def join("products:all", _message, socket) do
    initial_data = %{
      # TODO: serialize on schema level
      categories: Enum.map(
        LibTen.Categories.list_categories(),
        fn (category) ->
          %{id: category.id, name: category.name}
        end
      )
    }
    {:ok, initial_data, socket}
  end
end
