use Mix.Config

config :lib_ten,
  allowed_google_auth_domains: "${GOOGLE_OAUTH_ALLOWED_DOMAINS}",
  smtp_sender_email: "${SMTP_FROM_EMAIL}"

config :lib_ten, LibTenWeb.Endpoint,
  load_from_system_env: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false,
  secret_key_base: "${SECRET_KEY}",
  url: [host: "${HOSTNAME}"]

config :lib_ten, LibTen.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "${SMTP_SERVER}",
  port: "${SMTP_PORT}",
  username: "${SMTP_USERNAME}",
  password: "${SMTP_PASSWORD}"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "${GOOGLE_OAUTH_CLIENT_ID}",
  client_secret: "${GOOGLE_OAUTH_CLIENT_SECRET}"

config :logger, level: :info

postgres_credentials = [
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  hostname: "${DB_HOST}"
]

config :lib_ten, LibTen.Repo,
  postgres_credentials ++ [adapter: Ecto.Adapters.Postgres]
]

config :lib_ten, LibTenWeb.PostgresListener, postgres_credentials
