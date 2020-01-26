use Mix.Config

database_url = System.get_env("DATABASE_URL")

# Configure your database
case database_url do
  nil ->
    config :instagram, Instagram.Repo,
      username: "postgres",
      password: "postgres",
      database: "instagram_test",
      hostname: "localhost",
      pool: Ecto.Adapters.SQL.Sandbox
  url ->
    config :instagram, Instagram.Repo,
      url: url <> "instagram_test",
      pool: Ecto.Adapters.SQL.Sandbox
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :instagram, InstagramWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure arc
config :arc, storage: Arc.Storage.Local

# Configure guardian
config :instagram, InstagramWeb.Guardian,
  issuer: "instagram",
  secret_key: "rfXGOnrHqAvN3OdL0MZpE1ByHJD7xsxX4ii9g4Y+wAK5gHcUz0alo7rcycP1ShfF"
