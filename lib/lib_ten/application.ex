defmodule LibTen.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(LibTen.Repo, []),
      # Start the endpoint when the application starts
      {Phoenix.PubSub, name: LibTen.PubSub},
      supervisor(LibTenWeb.Endpoint, []),
      supervisor(LibTenWeb.PostgresListener, []),
      # Start your own worker by calling: LibTen.Worker.start_link(arg1, arg2, arg3)
      # worker(LibTen.Worker, [arg1, arg2, arg3]),
      worker(LibTen.Scheduler, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LibTen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LibTenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
