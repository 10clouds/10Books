defmodule LibTen.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lib_ten,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LibTen.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :parse_trans
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.7"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:jason, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_active_link, "~> 0.1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:ueberauth_google, "~> 0.8.0"},
      # TODO: Remove this one ueberauth will be fixed. Related issue -> https://github.com/ueberauth/ueberauth_github/issues/43
      {:poison, "~> 3.1"},
      {:ex_machina, "~> 2.1", only: :test},
      {:mock, "~> 0.2.0", only: :test},
      {:bamboo, "~> 1.2.0"},
      {:bamboo_smtp, "~> 1.7.0"},
      {:boltun, "~> 1.0.2"},
      {:distillery, "~> 2.0"},
      {:timex, "~> 3.1"},
      {:quantum, "~> 2.2.7"},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false},
      {:arc_ecto, "~> 0.11.1"}
      # TODO: Doesn't work with elixir 1.5.2, check later
      # {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "test.watch": ["test.watch --stale"]
    ]
  end
end
