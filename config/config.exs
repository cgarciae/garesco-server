# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configure your database
config :garesco_server, GarescoServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "garesco_server_dev",
  hostname: "192.168.99.100",
  port: 5432,
  pool_size: 10

# Configures the endpoint
config :garesco_server, GarescoServer.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "f0fJ+z31QygvZjcIfyzCvrwW6OUsy30TIBWEicPf2sMhA5/TgSPAUS1rQfg+KOKg",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: GarescoServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
