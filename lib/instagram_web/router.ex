defmodule InstagramWeb.Router do
  use InstagramWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Instagram.Guardian.Pipeline
  end

  pipeline :ensure_not_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InstagramWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController
  end

  scope "/", InstagramWeb do
    pipe_through [:browser, :ensure_not_auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  scope "/", InstagramWeb do
    pipe_through [:browser, :ensure_auth]

    get "/logout", SessionController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstagramWeb do
  #   pipe_through :api
  # end
end
