defmodule LibTen.Categories.Category do
  use Ecto.Schema

  import Ecto.Changeset

  alias LibTen.Repo
  alias LibTen.Categories.Category

  @available_colors [
    # {text, background}
    {"#eb42bc", "#fbdbf2"},
    {"#3c79e4", "#deeaff"},
    {"#7142eb", "#e4dbfb"},
    {"#fa732f", "#fbe7db"},
    {"#eb425f", "#fbdbe5"},
    {"#fdad1f", "#fbf3db"},
    {"#13b596", "#d4f5ef"},
    {"#36bbed", "#defeff"},
    {"#1ecf42", "#def5d4"},
    {"#230ab4", "#d5d0f0"},
    {"#434343", "#cfcdd5"},
    {"#7c3761", "#dbbdd0"},
    {"#3b6b54", "#bfd7cb"}
  ]

  schema "categories" do
    field :name, :string
    field :text_color, :string, null: false
    field :background_color, :string, null: false
    has_many :products, LibTen.Products.Product, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> set_color()
    |> capitalize_name()
  end

  def get_available_color() do
    initial_count =
      @available_colors
      |> Enum.map(fn {text_color, _} -> {text_color, 0} end)
      |> Enum.into(%{})
    colors_count =
      Category
      |> Repo.all()
      |> Enum.reduce(initial_count, fn(%{text_color: key}, acc) ->
        val = Map.get(acc, key)
        if val, do: Map.put(acc, key, val + 1), else: acc
      end)

    @available_colors
    |> Enum.sort(fn ({a_text_color, _}, {b_text_color, _}) ->
      colors_count[a_text_color] <= colors_count[b_text_color]
    end)
    |> Enum.at(0)
  end

  defp set_color(changeset) do
    if !changeset.valid? || get_field(changeset, :text_color) do
      changeset
    else
      {text_color, background_color} = get_available_color()
      changeset
      |> put_change(:text_color, text_color)
      |> put_change(:background_color, background_color)
    end
  end

  defp capitalize_name(changeset) do
    if changeset.valid? do
      {first_char, rest} = get_field(changeset, :name) |> String.split_at(1)
      name = String.capitalize(first_char) <> rest

      changeset
      |> put_change(:name, name)
    else
      changeset
    end
  end
end
