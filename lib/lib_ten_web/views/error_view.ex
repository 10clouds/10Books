defmodule LibTenWeb.ErrorView do
  use LibTenWeb, :view

  @error_types %{
    not_found: "NOT_FOUND",
    record_invalid: "RECORD_INVALID"
  }

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("error.json", %{type: type} = _assigns) do
    %{type: @error_types[type]}
  end

  def render("error.json", %Ecto.Changeset{} = assigns) do
    errors =
      Enum.map(assigns.errors, fn {field, detail} ->
        %{
          source: %{pointer: "/data/attributes/#{field}"},
          title: "Invalid Attribute",
          detail: render_detail(detail)
        }
      end)

    %{type: @error_types.record_invalid, errors: errors}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  defp render_detail(message) do
    message
  end
end
