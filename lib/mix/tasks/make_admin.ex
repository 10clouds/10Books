defmodule Mix.Tasks.MakeAdmin do
  @moduledoc """
  Makes the specified users an admin. The user must already exist in
  the system, ie. they must have logged in at least once before running
  this mix task.

  ## Usage

      mix make_admin user@example.com
  """

  use Mix.Task

  def run([email]) do
    Mix.EctoSQL.ensure_started(LibTen.Repo, [])

    LibTen.Accounts.get_by!(%{email: String.downcase(email)})
    |> LibTen.Accounts.Users.update(%{is_admin: true})

    Mix.shell().info("Made #{email} an admin")
  end

  def run([]) do
    Mix.shell().error("Please provide an email as an argument")
  end

  def run(_args) do
    Mix.shell().error("Please provide an email as the only argument")
  end
end
