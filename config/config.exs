use Mix.Config

config :skynet, SkynetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oXIePRmZbOMSNnmR9puvehgW0dLrHBH/QPNPcP466llC9zE7bWl5jc9fQeRE/Ar+",
  render_errors: [view: SkynetWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Skynet.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
