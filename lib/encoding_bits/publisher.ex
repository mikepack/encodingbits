defmodule EncodingBits.Publisher do
  def publish do
    {_, files} = File.ls(EncodingBits.PathHelpers.raw_articles_path)
    publish_file(files)
  end

  def update_existing do
    {_, raw_files} = File.ls(EncodingBits.PathHelpers.raw_articles_path)
    {_, published_files} = File.ls(EncodingBits.PathHelpers.published_articles_path)

    update_file(raw_files, published_files)
  end

  defp publish_file([file | files], date // :erlang.date, overwrite // false) do
    {year, month, day} = date

    if Regex.match?(%r/.*.md/g, file) do
      {raw, published} = article_paths

      # Grab the markdown
      {:ok, md_file} = File.open("#{raw}/#{file}", [:read])
      md_contents = IO.binread(md_file, 99999)
      File.close(md_file)

      # Convert markdown to HTML
      html_contents = Markdown.to_html(md_contents)

      # Write HTML
      path = "#{published}/#{year}-#{month}-#{day}-#{basename(file)}.html"
      if not slug_published?(basename(file)) or overwrite do
        File.mkdir_p(published)
        {:ok, html_file} = File.open(path, [:write])
        IO.binwrite(html_file, html_contents)
        File.close(html_file)
      end
    end

    publish_file(files)
  end

  defp publish_file([], _, _) do end

  defp basename(filename) do
    captures = Regex.named_captures(%r/(.*?[\/])*(?<basename>.*?)((?:\.\w+\z|\z))/g, filename)
    captures[:basename]
  end

  defp slug_published?(slug) do
    case File.ls(EncodingBits.PathHelpers.published_articles_path) do
      {:error, _} -> false
      {_, published_files} ->
        not nil? Enum.find published_files, fn(filename) ->
          Regex.match?(%r/#{slug}/, filename)
        end
    end
  end

  defp update_file([file | files], published_files) do
    # Grab the published date of this article
    case published_date_for(file, published_files) do
      {:error} -> IO.puts "#{file} has not been published, skipping."
      {year, month, day} ->
        # Rewrite the file with the same date
        publish_file([file], {year, month, day}, true)
    end

    update_file(files, published_files)
  end

  defp update_file([], _) do end

  defp article_paths do
    {EncodingBits.PathHelpers.raw_articles_path, EncodingBits.PathHelpers.published_articles_path}
  end

  defp published_date_for(file, published_files) do
    slug = Regex.named_captures(%r/(?<slug>.*?).md/g, file)[:slug]

    file = Enum.find published_files, fn(filename) ->
      Regex.match?(%r/-#{slug}.html/g, filename)
    end

    case file do
      nil -> {:error}
      _ ->
        captures = Regex.named_captures(%r/(?<year>.*?)-(?<month>.*?)-(?<day>.*?)-(?<slug>.*?).html/g, file)
        {captures[:year], captures[:month], captures[:day]}
    end
  end
end