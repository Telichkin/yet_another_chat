# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :yet_another_chat,
  ecto_repos: [YetAnotherChat.Repo],
  password_salt: "123"

# Configures the endpoint
config :yet_another_chat, YetAnotherChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "A/k1oBKb3hc6Rzh7ZAqe9LohrhCCBMMrhLQRMVF3rAbOAmLHjYCSaho/aSIJyEFH",
  render_errors: [view: YetAnotherChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: YetAnotherChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
