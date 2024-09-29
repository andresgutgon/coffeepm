import Config

config :coffee,
  ecto_repos: [Coffee.Repo],
  generators: [timestamp_type: :utc_datetime]

config :coffee, CoffeeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: CoffeeWeb.ErrorHTML, json: CoffeeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Coffee.PubSub,
  live_view: [signing_salt: "uBJ9zPTM"]

config :esbuild,
  version: "0.17.11",
  coffee: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  coffee: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tails,
  colors_file: Path.join(File.cwd!(), "assets/tailwind.colors.json")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

if Mix.env() == :dev do
  config :mix_test_watch,
    clear: true
end

import_config "#{config_env()}.exs"
