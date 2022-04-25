import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :life, Life.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5434,
  database: "life_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :life, LifeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rsyFZYmymoU/5SvVKQ6iBW377/s3VACrikHugpbNm3r3OdWREEVMcqEowmLkFMG4",
  server: false

# In test we don't send emails.
config :life, Life.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
# config :logger, level: :warn
config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :debug]
  ]

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
