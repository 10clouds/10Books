use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
end

environment :prod do
  set include_erts: true
  set include_src: false
  set pre_start_hooks: "rel/hooks/pre_start"
end

release :lib_ten do
  set commands: [
    gen_session_key: "rel/commands/gen_session_key.sh"
  ]

  # NOTE:
  # Ideally we don't want to have any cookie here, so one will
  # be created automatically for every lib_ten instance.
  #
  # Be we can't do that because of
  # https://github.com/bitwalker/distillery/issues/428
  #
  # 😢
  set cookie: LibTen.ReleaseTasks.gen_random_key(128)
  set version: current_version(:lib_ten)
end
