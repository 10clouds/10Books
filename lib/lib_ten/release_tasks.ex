defmodule LibTen.ReleaseTasks do
  # Based on
  # https://hexdocs.pm/distillery/guides/running_migrations.html
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @app :lib_ten
  @repos Application.get_env(@app, :ecto_repos, [])

  def migrate do
    start_services()
    Enum.each(@repos, &run_migrations_for/1)
    stop_services()
  end

  def gen_random_key(key_length) do
    :crypto.strong_rand_bytes(key_length)
    |> Base.encode64
    |> binary_part(0, key_length)
  end

  def print_random_key(length) do
    {key_length, _} = Integer.parse(length)
    gen_random_key(key_length)
    |> IO.puts
  end

  defp start_services do
    IO.puts("Loading #{@app}..")
    Application.load(@app)

    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
