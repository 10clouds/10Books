ExUnit.start(trace: true)

Ecto.Adapters.SQL.Sandbox.mode(LibTen.Repo, :manual)
Application.ensure_all_started(:ex_machina)
