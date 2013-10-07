defmodule EncodingBits.Articles do
  def all do
    case File.ls(EncodingBits.PathHelpers.published_articles_path) do
      {:error, _} -> []
      {:ok, files} ->
        Enum.map files, fn(filename) ->
          captures = Regex.named_captures(%r/(?<year>.*?)-(?<month>.*?)-(?<day>.*?)-(?<slug>.*?).html/g, filename)

          {:ok, file} = File.open("#{EncodingBits.PathHelpers.published_articles_path}/#{filename}", [:read])
          contents = IO.binread(file, 99999)
          File.close(file)
          title = Regex.named_captures(%r/<h1>(?<title>.*?)<\/h1>/g, contents)[:title]

          [slug: captures[:slug], year: captures[:year], month: captures[:month],
           day: captures[:day], title: title, body: contents]
        end
    end
  end

  def find(slug) do
    article = Enum.find all, fn(possible_article) ->
      possible_article[:slug] == slug
    end

    case article do
      nil -> {:error, :not_found}
      _ -> {:ok, article}
    end
  end
end