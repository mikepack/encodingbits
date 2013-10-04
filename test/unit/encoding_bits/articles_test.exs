defmodule EncodingBits.ArticlesTest do
  use ExUnit.Case
  require EncodingBits.Articles
  import EncodingBits.Test.FileHelpers

  setup do
    { :ok, raw_path: EncodingBits.PathHelpers.raw_articles_path, published_path: EncodingBits.PathHelpers.published_articles_path }
  end

  teardown meta do
    cleanup([meta[:raw_path], meta[:published_path]])
    :ok
  end

  test "#all without any published articles returns an empty list" do
    assert EncodingBits.Articles.all == []
  end

  test "#all returns info about all articles, in reverse chronological order", meta do
    body = write_published_file(meta)
    write_published_file(meta, "2001-02-01")

    all = [[slug: "the-title", year: "2001", month: "02",
                      day: "01", title: "The Title", body: body],
           [slug: "the-title", year: "2000", month: "02",
                      day: "01", title: "The Title", body: body]]
    assert EncodingBits.Articles.all == all
  end

  test "#find returns {:error, :not_found} when it can't find the article" do
    assert EncodingBits.Articles.find("nonexistent-slug") == {:error, :not_found}
  end

  test "#find returns {:ok, article details} when it find an article", meta do
    body = write_published_file(meta)

    details = [slug: "the-title", year: "2000", month: "02",
               day: "01", title: "The Title", body: body]

    assert EncodingBits.Articles.find("the-title") == {:ok, details}
  end

  defp write_published_file(meta, date // "2000-02-01") do
    body = "<h1>The Title</h1>"

    # Write body to file
    File.mkdir_p(meta[:published_path])
    write("#{meta[:published_path]}/#{date}-the-title.html", body)

    body
  end
end