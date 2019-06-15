defmodule LibTenWeb.Router do
  use LibTenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", LibTenWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", AuthController, :index

    scope "/" do
      pipe_through :authenticate_user
      get "/library", ProductsController, :library
      get "/orders", ProductsController, :orders

      scope "/" do
        pipe_through :validate_admin
        get "/all", ProductsController, :all

        scope "/admin", as: :admin do
          resources "/users", Admin.UserController, only: [:index, :edit, :update]
          resources "/categories", Admin.CategoryController, except: [:show]
          get "/settings", Admin.SettingsController, :index
          put "/settings", Admin.SettingsController, :update
        end
      end
    end

    scope "/auth" do
      get "/sign_out", AuthController, :sign_out
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      user_id ->
        user = LibTen.Accounts.get_by!(%{id: user_id})

        token =
          Phoenix.Token.sign(conn, "current_user_token", %{
            id: user_id,
            is_admin: user.is_admin
          })

        conn
        |> assign(:current_user_token, token)
        |> assign(:current_user, user)
        |> assign(:settings, LibTen.Admin.get_settings())
    end
  end

  defp validate_admin(conn, _) do
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
