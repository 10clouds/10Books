defmodule LibTen.Admin do
  import Ecto.Query, warn: false
  alias LibTen.Repo
  alias LibTen.Admin.Settings

  def get_settings() do
    case Repo.one(Settings) do
      nil ->
        %Settings{}
        |> change_settings()
        |> Repo.insert!
      settings -> settings
    end
  end

  def update_settings(%Settings{} = settings, attrs) do
    settings
    |> Settings.changeset(attrs)
    |> Repo.update()
  end

  def change_settings(%Settings{} = settings) do
    Settings.changeset(settings, %{})
  end
end
