# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discord_mock, DiscordMock.Guardian,
  issuer: "discord_mock",
  secret_key: "Secret key. Use `mix guardian.gen.secret` to generate one"

config :discord_mock,
  ecto_repos: [DiscordMock.Repo]

# Configures the endpoint
config :discord_mock, DiscordMockWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "A4kdFC50rqTkHkPWRcQPh/JlJON4Xal0QiARnWqnYmCTWy3HQK3GuYJKl4DKR+Sw",
  render_errors: [view: DiscordMockWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DiscordMock.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mime, :types, %{
  "application/json" => ["json"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
