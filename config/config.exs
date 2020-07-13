# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bolon,
  ecto_repos: [Bolon.Repo]

# Configures the endpoint
config :bolon, BolonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zMMaMyQeSVo2NNNAz706ZvL3HVWMP2o2M9+L8iYBy03S2FHIsKbJDc0NvUQKqDfr",
  render_errors: [view: BolonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bolon.PubSub,
  live_view: [signing_salt: "o7K9meYJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
