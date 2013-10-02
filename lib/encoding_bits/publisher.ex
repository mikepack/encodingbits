defmodule EncodingBits.Publisher do
  def publish do
    {_, files} = File.ls(EncodingBits.Dynamo.config[:dynamo][:raw_articles_path])
    publish_file(files)
  end

  def update_existing do
  end

  defp publish_file([file | files]) do
    config = EncodingBits.Dynamo.config
    raw = config[:dynamo][:raw_articles_path]
    published = config[:dynamo][:published_articles_path]

    # Grab the markdown
    {:ok, md_file} = File.open("#{raw}/#{file}", [:read])
    md_contents = IO.binread(md_file, 99999)
    File.close(md_file)

    # Convert markdown to HTML
    {year, month, day} = :erlang.date
    html_contents = """
    #{Markdown.to_html(md_contents)}
    <span class="published-on">Published on #{month}/#{day}/#{year}</span>
    """

    # Write HTML
    if not File.exists?("#{published}/#{basename(file)}.html") do
      File.mkdir_p(published)
      {:ok, html_file} = File.open("#{published}/#{basename(file)}.html", [:write])
      IO.binwrite(html_file, html_contents)
      File.close(html_file)
    end

    publish_file(files)
  end

  defp publish_file([]) do
  end

  defp basename(filename) do
    captures = Regex.named_captures(%r/(.*?[\/])*(?<basename>.*?)((?:\.\w+\z|\z))/g, filename)
    captures[:basename]
  end
end