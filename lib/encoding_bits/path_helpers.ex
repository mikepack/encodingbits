defmodule EncodingBits.PathHelpers do
  def raw_articles_path do
    paths = [dev: Path.expand("../../../../articles/published", :code.priv_dir(:encoding_bits)),
             test: Path.expand("../tmp/test/articles", :code.priv_dir(:encoding_bits)),
             prod: Path.expand("../articles/published", :code.priv_dir(:encoding_bits))]
    paths[EncodingBits.Dynamo.config[:dynamo][:env]]
  end

  def published_articles_path do
    paths = [dev: Path.expand("../../../../priv/published_articles", :code.priv_dir(:encoding_bits)),
             test: Path.expand("../tmp/test/published_articles", :code.priv_dir(:encoding_bits)),
             prod: Path.expand("published_articles", :code.priv_dir(:encoding_bits))]
    paths[EncodingBits.Dynamo.config[:dynamo][:env]]
  end
end