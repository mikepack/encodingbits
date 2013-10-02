config :dynamo,
  # For testing we compile modules on demand,
  # but there isn't a need to reload them.
  compile_on_demand: true,
  reload_modules: false,

  raw_articles_path: Path.expand("../../../tmp/articles", __FILE__),
  published_articles_path: Path.expand("../../../tmp/published_articles", __FILE__)

config :server, port: 8888
