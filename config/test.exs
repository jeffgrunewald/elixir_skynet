use Mix.Config

config :skynet, SkynetWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
