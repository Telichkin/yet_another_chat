use Mix.Config

config :yet_another_chat, YetAnotherChat.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "yet-another-chat.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :yet_another_chat, YetAnotherChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true  

config :logger, level: :info
