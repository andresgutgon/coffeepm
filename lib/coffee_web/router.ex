defmodule CoffeeWeb.Router do
  use CoffeeWeb, :router

  import CoffeeWeb.Auth.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CoffeeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CoffeeWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", CoffeeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:coffee, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CoffeeWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", CoffeeWeb.Auth, as: :auth do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session(
      :redirect_if_user_is_authenticated,
      on_mount: [{CoffeeWeb.Auth.UserAuth, :redirect_if_user_is_authenticated}],
      layout: {CoffeeWeb.Layouts, :focus}
    ) do
      live "/signup", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/forgot-password", UserForgotPasswordLive, :new
      live "/forgot-password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/account", CoffeeWeb.Auth, as: :auth do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CoffeeWeb.Auth.UserAuth, :ensure_authenticated}] do
      live "/", UserSettingsLive, :edit

      live "/confirm-email/:token",
           UserSettingsLive,
           :confirm_email
    end
  end

  scope "/auth", CoffeeWeb.Auth, as: :auth do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{CoffeeWeb.Auth.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
