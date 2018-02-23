use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :transaction_api, TransactionApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :transaction_api, TransactionApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "cyrusghazanfar",
  password: "password",
  database: "transaction_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
