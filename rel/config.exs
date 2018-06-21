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
  set pre_start_hook: "rel/hooks/pre_start.sh"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :lib_ten do
  random_cookie_length = 128
  random_cookie =
    :crypto.strong_rand_bytes(random_cookie_length)
    |> Base.encode64
    |> binary_part(0, random_cookie_length)

  # NOTE:
  # Ideally we don't want to have any cookie here, so one will
  # be created automatically for every lib_ten instance.
  #
  # Be we can't do that because of
  # https://github.com/bitwalker/distillery/issues/428
  #
  # 😢
  set cookie: random_cookie
  set version: current_version(:lib_ten)
end
