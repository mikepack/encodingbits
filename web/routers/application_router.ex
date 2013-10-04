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
    conn = conn.assign(:articles, EncodingBits.Articles.all)
    render conn, "index.html"
  end

  get "/feed.atom" do
    conn = conn.assign(:articles, EncodingBits.Articles.all)
    conn = conn.put_resp_header("Content-Type", "text/xml")
    render conn, "feed.atom"
  end

  get "/:slug" do
    case EncodingBits.Articles.find(slug) do
      {:ok, article} ->
        conn = conn.assign(:article, article)
        render conn, "post.html"
      {:error, :not_found} ->
        conn = conn.status(404)
        render conn, "404.html"
    end
  end
end
