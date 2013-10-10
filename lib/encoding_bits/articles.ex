defmodule EncodingBits.Articles do
  def all do
    case File.ls(EncodingBits.PathHelpers.published_articles_path) do
      {:error, _} -> []
      {:ok, files} ->
        Enum.map sort(files), fn(filename) ->
          captures = details(filename)

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

  def details(filename) do
    captures = Regex.named_captures(%r/(?<year>.*?)-(?<month>.*?)-(?<day>.*?)-(?<slug>.*?).html/g, filename)
    [year: binary_to_integer(captures[:year]), month: binary_to_integer(captures[:month]),
     day: binary_to_integer(captures[:day]), slug: captures[:slug]]
  end

  defp sort(files) do
    Enum.sort files, fn(a, b) ->
      captures_a = details(a)
      captures_b = details(b)
      compare([captures_a[:year], captures_b[:year], captures_a[:month],
               captures_b[:month], captures_a[:day], captures_b[:day]])
    end
  end

  # Compare year/year or month/month or day/day
  defp compare([]) do true end

  defp compare(values) do
    [a, b] = Enum.take(values, 2)
    cond do
      a > b  -> true
      a < b  -> false
      a == b -> compare(Enum.drop(values, 2))
    end
  end
end