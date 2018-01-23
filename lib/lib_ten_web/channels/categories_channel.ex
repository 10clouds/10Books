defmodule LibTenWeb.CategoriesChannel do
  use Phoenix.Channel
  alias LibTen.Categories
  alias LibTen.Categories.Category

  def broadcast_update(category_id) do
    try do
      category = Categories.get_category!(category_id)
      LibTenWeb.Endpoint.broadcast!("categories", "updated", to_json_map(category))
    rescue
      Ecto.NoResultsError ->
        LibTenWeb.Endpoint.broadcast!("categories", "deleted", %{
          id: category_id
        })
    end
  end


  def join("categories", _message, socket) do
    categories = Categories.list_categories() |> to_json_map
    {:ok, %{payload: categories}, socket}
  end


  defp to_json_map(%Category{} = category) do
    Map.take(category, [:id, :name])
  end

  defp to_json_map(categories) do
    Enum.map(categories, &to_json_map/1)
  end
end
