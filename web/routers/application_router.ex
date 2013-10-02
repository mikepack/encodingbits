defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch :params

    conn.assign :layout, "main"
  end

  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter

  get "/" do
    render conn, "index.html"
  end

  get "/:title" do
    case article_body(title) do
      {:ok, body} ->
        conn = conn.assign(:title, title)
        conn = conn.assign(:body, body)
        render conn, "post.html"
      {:not_found} ->
        render conn, "404.html"
    end
  end

  def article_body(slug) do
    config = EncodingBits.Dynamo.config

    case File.open("#{config[:dynamo][:published_articles_path]}/#{slug}.html", [:read]) do
      {:ok, file} ->
        contents = IO.binread(file, 99999)
        File.close(file)
        {:ok, contents}
      {:error, _} -> {:not_found}
    end
  end
end
