# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :engaged,
  ecto_repos: [Engaged.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :engaged, EngagedWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: EngagedWeb.ErrorHTML, json: EngagedWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Engaged.PubSub,
  live_view: [signing_salt: "PPlDwtXi"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :engaged, Engaged.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  engaged: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  engaged: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Mint for tesla requests
config :tesla, adapter: Tesla.Adapter.Mint

# Set the YouTube API key in other environment-specific files
config :engaged, youtube_api_key: "API_KEY_NOT_REAL"

# Add Oban configuration
# config/config.exs
config :engaged, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10, youtube: 10, monitors: 10],
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       # Restart paused queues every hour
       {"@hourly", Engaged.Workers.APIMonitorWorker}
     ]}
  ],
  repo: Engaged.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config("#{config_env()}.exs")
