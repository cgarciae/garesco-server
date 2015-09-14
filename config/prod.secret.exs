use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :garesco_server, GarescoServer.Endpoint,
  secret_key_base: "EKedGmofSliKJtTb03d8IUQVIQ52b56l+GlQxdsC8/JjLfNygkrN3tXMaoknT1zQ"

# Configure your database
config :garesco_server, GarescoServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "garesco_server_prod",
  pool_size: 20
