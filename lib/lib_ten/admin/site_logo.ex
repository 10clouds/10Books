defmodule LibTen.Admin.SiteLogo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .gif .png .svg)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def filename(_, _) do
    "admin/site_logo"
  end

  def default_url(_) do
    "/images/logo-10books.svg"
  end
end
