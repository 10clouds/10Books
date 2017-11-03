defmodule LibTenWeb.Router do
  use LibTenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LibTenWeb do
    pipe_through :browser # Use the default browser stack

    get "/", AuthController, :index

    scope "/" do
      pipe_through :authenticate_user
      get "/library", LibraryController, :index
      resources "/products", ProductController

      scope "/admin", Admin, as: :admin do
        pipe_through :is_admin
        resources "/users", UserController, only: [:index, :edit, :update]
        resources "/categories", CategoryController
      end
    end

    scope "/auth" do
      get "/sign_out", AuthController, :sign_out
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", LibTenWeb do
  #   pipe_through :api
  # end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, LibTen.Accounts.get_by!(%{id: user_id}))
    end
  end

  defp is_admin(conn, _) do
    if conn.assigns[:current_user].is_admin do
      conn
    else
      conn
      |> put_status(:not_found)
      |> Phoenix.Controller.render(LibTenWeb.ErrorView, :"404")
      |> halt()
    end
  end
end
