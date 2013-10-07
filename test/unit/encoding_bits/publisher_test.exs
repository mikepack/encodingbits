defmodule EncodingBits.PublisherTest do
  use ExUnit.Case
  require EncodingBits.Publisher
  import EncodingBits.Test.FileHelpers

  setup do
    { :ok, raw_path: EncodingBits.PathHelpers.raw_articles_path, published_path: EncodingBits.PathHelpers.published_articles_path }
  end

  teardown meta do
    cleanup([meta[:raw_path], meta[:published_path]])
    :ok
  end

  test "#publish converts markdown to a static file", meta do
    body = """
    # The Title

    The **copy**.
    """

    # Write body to file
    File.mkdir_p(meta[:raw_path])
    write("#{meta[:raw_path]}/the-title.md", body)

    # Publish content
    EncodingBits.Publisher.publish

    # Read published contents from file
    {year, month, day} = :erlang.date
    contents = read("#{meta[:published_path]}/#{year}-#{month}-#{day}-the-title.html")

    assert contents == """
    <h1>The Title</h1>

    <p>The <strong>copy</strong>.</p>
    """
  end

  test "#publish does not replace an already published file", meta do
    body1 = "# First Title"
    body2 = "# Second Title"

    File.mkdir_p(meta[:raw_path])
    write("#{meta[:raw_path]}/the-title.md", body1)

    EncodingBits.Publisher.publish

    write("#{meta[:raw_path]}/the-title.md", body2)

    EncodingBits.Publisher.publish

    {year, month, day} = :erlang.date
    contents = read("#{meta[:published_path]}/#{year}-#{month}-#{day}-the-title.html")

    assert contents == """
    <h1>First Title</h1>
    """
  end

  test "#publish does not republish an article on a different day", meta do
    body = "# The Title"

    File.mkdir_p(meta[:raw_path])
    write("#{meta[:raw_path]}/the-title.md", body)

    EncodingBits.Publisher.publish

    {year, month, day} = :erlang.date
    published_filename = change_published_date("the-title", {year - 1, month, day}, meta)

    EncodingBits.Publisher.publish

    assert not File.exists?("#{meta[:published_path]}/#{year}-#{month}-#{day}-the-title.html")
  end

  test "#update_existing reprocesses all published articles, keeping the same published date", meta do
    body1 = """
    # The Title

    A typo.
    """
    body2 = """
    # The Title

    A fix.
    """

    File.mkdir_p(meta[:raw_path])
    write("#{meta[:raw_path]}/the-title.md", body1)

    EncodingBits.Publisher.publish

    # Changing published date
    {year, month, day} = :erlang.date
    published_filename = change_published_date("the-title", {year - 1, month, day}, meta)

    write("#{meta[:raw_path]}/the-title.md", body2)

    EncodingBits.Publisher.update_existing

    contents = read(published_filename)

    assert contents == """
    <h1>The Title</h1>

    <p>A fix.</p>
    """
  end

  defp change_published_date(slug, existing_date // :erlang.date, new_date, meta) do
    {e_year, e_month, e_day} = existing_date
    {n_year, n_month, n_day} = new_date

    old_filename = "#{meta[:published_path]}/#{e_year}-#{e_month}-#{e_day}-#{slug}.html"
    published_filename = "#{meta[:published_path]}/#{n_year}-#{n_month}-#{n_day}-#{slug}.html"

    File.cp(old_filename, published_filename)
    File.rm(old_filename)

    published_filename
  end
end