use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"W^`qJjEHc/4xg0{5/3eO$Lx,.cx/`aQ>jjIcX&I84Cq6f9u!:7;x.u&u^j2pDH&}"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"Mp%J5WW?8.weBZIo!C@0Q2.cNb<=:$aO`PE5uu@?iiyEPz.K(Y2;vx!OEA*2.OZ~"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :lib_ten do
  set version: current_version(:lib_ten)
end

