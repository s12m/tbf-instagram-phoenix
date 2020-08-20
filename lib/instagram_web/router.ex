defmodule InstagramWeb.Router do
  use InstagramWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  # Only authenticated
  scope "/", InstagramWeb do
    pipe_through [:browser, :protected]

    resources "/posts", PostController, except: [:show]
  end

  scope "/", InstagramWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstagramWeb do
  #   pipe_through :api
  # end
end
