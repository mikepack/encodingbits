defmodule EncodingBits.PathHelpers do
  def raw_articles_path do
    paths = unquote(quote do
      [dev: Path.expand("../../../articles/published", __FILE__),
       test: Path.expand("../../../tmp/test/articles", __FILE__),
       prod: Path.expand("../../../articles/published", __FILE__)]
    end)
    paths[EncodingBits.Dynamo.config[:dynamo][:env]]
  end

  def published_articles_path do
    paths = unquote(quote do
      [dev: Path.expand("../../../priv/published_articles", __FILE__),
       test: Path.expand("../../../tmp/test/published_articles", __FILE__),
       prod: Path.expand("../../../priv/published_articles", __FILE__)]
    end)
    paths[EncodingBits.Dynamo.config[:dynamo][:env]]
  end
end