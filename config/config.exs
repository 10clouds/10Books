# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lib_ten,
  ecto_repos: [LibTen.Repo]

# TODO: Ideally we want to have separate i18n overwrites for different apps
config :lib_ten, :title, "10Books"

# Configures the endpoint
config :lib_ten, LibTenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TmB2X43BwwgU4K5Hkq9f/lVaQmtFGobmRsxJ5ZDhAlogzSenkVR5tfvRRNuFDDIL",
  render_errors: [view: LibTenWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LibTen.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "471584135384-574afafjms570m3v6t1sekijh1lptral.apps.googleusercontent.com",
  client_secret: "W9napBOnGFb9FcPz2Tud6fqE"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
