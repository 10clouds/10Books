# For local development, copy this file and rename
# to config.secret.exs
use Mix.Config

config :lib_ten,
  allowed_google_auth_domains: "gmail.com"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "client_id.apps.googleusercontent.com",
  client_secret: "client_secret"
