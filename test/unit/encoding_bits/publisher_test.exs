defmodule EncodingBits.PublisherTest do
  use ExUnit.Case
  require EncodingBits.Publisher

  setup do
    config = EncodingBits.Dynamo.config
    { :ok, raw_path: config[:dynamo][:raw_articles_path], published_path: config[:dynamo][:published_articles_path] }
  end

  teardown meta do
    cleanup(["#{meta[:raw_path]}/the-title.md", "#{meta[:published_path]}/the-title.html"])
    :ok
  end

  test "#publish", meta do
    body = """
    # The Title

    The **copy**.
    """

    # Write body to file
    File.mkdir_p(meta[:raw_path])
    write_md("#{meta[:raw_path]}/the-title.md", body)

    # Publish content
    EncodingBits.Publisher.publish

    # Read published contents from file
    contents = read_html("#{meta[:published_path]}/the-title.html")

    {year, month, day} = :erlang.date
    assert contents == """
    <h1>The Title</h1>

    <p>The <strong>copy</strong>.</p>

    <span class="published-on">Published on #{month}/#{day}/#{year}</span>
    """
  end

  test "#publish does not replace an already published file", meta do
    body1 = "# First Title"
    body2 = "# Second Title"

    File.mkdir_p(meta[:raw_path])
    write_md("#{meta[:raw_path]}/the-title.md", body1)

    EncodingBits.Publisher.publish

    write_md("#{meta[:raw_path]}/the-title.md", body2)

    EncodingBits.Publisher.publish

    contents = read_html("#{meta[:published_path]}/the-title.html")

    {year, month, day} = :erlang.date
    assert contents == """
    <h1>First Title</h1>

    <span class="published-on">Published on #{month}/#{day}/#{year}</span>
    """
  end

  test "#update_existing" do
    assert false
  end

  def write_md(path, body) do
    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, body)
    File.close(file)
  end

  def read_html(path) do
    {:ok, file} = File.open(path, [:read])
    contents = IO.binread(file, 99999)
    File.close(file)
    contents
  end

  def cleanup([file | files]) do
    File.rm(file)
    cleanup(files)
  end

  def cleanup([]) do
  end
end