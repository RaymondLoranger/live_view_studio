import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :live_view_studio, LiveView.Studio.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "live_view_studio_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_view_studio, LiveView.StudioWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base:
    "Ku7b0ZSLQ3jczve4KztfK9ND+yS2+NjLI0UawyByX9pNkHR1xdqCv71NlxJcjvpg",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
