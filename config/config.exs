# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :instagram,
  ecto_repos: [Instagram.Repo]

# Configures the endpoint
config :instagram, InstagramWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "g+FUyJfqlWJwsBWOB1dEGtYj+UO6QyRss8jCAvux/GNw8g2RTLgihl+KsiQfBRiO",
  render_errors: [view: InstagramWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Instagram.PubSub,
  live_view: [signing_salt: "yzHi1OZc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures pow
config :instagram, :pow,
  user: Instagram.Users.User,
  repo: Instagram.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
