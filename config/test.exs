use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yet_another_chat, YetAnotherChatWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger,
 level: :warn,
 backend: [:console],
 compile_time_purge_level: :debug

# Configure your database
config :yet_another_chat, YetAnotherChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "yet_another_chat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
