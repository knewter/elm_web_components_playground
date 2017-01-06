# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backend,
  ecto_repos: [Backend.Repo]

# Configures the endpoint
config :backend, Backend.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1vOLUmFFWV/9nVeeeJcCJ3tiRIAJcbIk0TyWvMIMpVIBQsY6g5uJKMvq3BQKemWC",
  render_errors: [view: Backend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :stripity_stripe, api_key: System.get_env("STRIPE_SECRET_KEY")

config :guardian, Guardian,
  allowed_algos: ["ES512"], # optional
  verify_module: Guardian.JWT,  # optional
  verify_issuer: true, # optional
  issuer: "Elm Web Components Backend",
  ttl: { 30, :days },
  #ttl: { 15, :seconds }, # Just an easy way to test api key expiration 'for realz'
  secret_key: {Backend.SecretKey, :fetch},
  serializer: Backend.GuardianSerializer

config :backend, :aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket_name: "s3directupload-elixirsips",
  region: "us-west-2"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
