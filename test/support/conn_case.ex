defmodule LibTenWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import LibTenWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint LibTenWeb.Endpoint

      def sign_in(conn, user) do
        conn
        |> bypass_through(LibTenWeb.Router, :browser)
        |> get("/")
        |> put_session(:user_id, user.id)
        |> send_resp(:ok, "")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LibTen.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LibTen.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
