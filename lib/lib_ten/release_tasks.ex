defmodule LibTen.ReleaseTasks do
  # Based on
  # https://github.com/bitwalker/distillery/blob/24678a91e1df889e350b7a94ce306257fdb81c6b/docs/Running%20Migrations.md

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @otp_app :lib_ten

  def migrate do
    prepare()
    Enum.each(repos(), &run_migrations_for/1)
  end

  defp prepare do
    IO.puts "Loading #{@otp_app}.."
    :ok = Application.load(@otp_app)

    IO.puts "Starting dependencies.."
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts "Starting repos.."
    Enum.each(repos(), &(&1.start_link(pool_size: 1)))
  end

  defp repos, do: Application.get_env(@otp_app, :ecto_repos, [])

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    Path.join([priv_dir(app), repo_underscore, filename])
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
