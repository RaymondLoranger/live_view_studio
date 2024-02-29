# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :live_view_studio,
  namespace: LiveView.Studio,
  ecto_repos: [LiveView.Studio.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :live_view_studio, LiveView.StudioWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: LiveView.StudioWeb.ErrorHTML, json: LiveView.StudioWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LiveView.Studio.PubSub,
  live_view: [signing_salt: "N293RMYU"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  live_view_studio: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.1",
  live_view_studio: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]
  
import_config "config_logger.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
