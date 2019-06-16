defmodule LibTen.Admin.SiteLogo do
  use Arc.Definition
  use Arc.Ecto.Definition

  def filename(_, _) do
    "admin/site_logo"
  end

  def default_url(_) do
    "/images/logo-10books.svg"
  end
end
