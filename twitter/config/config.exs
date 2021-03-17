# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :twitter, TwitterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7+NspJ+h0i9Tr57z4tIYkjmI7GVESBT33kU6k/FHXFUqPajSTYCjkIYT5iIx6GXo",
  render_errors: [view: TwitterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Twitter.PubSub,
  live_view: [signing_salt: "x/4JWWQB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

#user locally stored (NOT IN REPO) secrets
# for Twitter APIs
#TODO: add add deploy script that inserts these as environment variables
config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
