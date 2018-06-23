use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lib_ten, LibTenWeb.Endpoint,
  http: [port: 4001],
  server: false

config :lib_ten,
  allowed_google_auth_domains: "test.com, 10clouds.com"

# Print only warnings and errors during test
config :logger, level: :warn

config :lib_ten, LibTen.Mailer,
  adapter: Bamboo.TestAdapter

# Configure your database
postgres_credentials = [
  username: "postgres",
  password: "postgres",
  database: "lib_ten_test",
  hostname: "localhost",
]
config :lib_ten, LibTen.Repo,
  postgres_credentials ++ [
    adapter: Ecto.Adapters.Postgres,
    pool: Ecto.Adapters.SQL.Sandbox
  ]
config :lib_ten, LibTenWeb.PostgresListener, postgres_credentials
