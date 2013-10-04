defmodule ApplicationRouterTest do
  use EncodingBits.TestCase
  use Dynamo.HTTP.Case

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter

  test "returns OK" do
    conn = get("/")
    assert conn.status == 200
  end

  test "article not found returns 404" do
    conn = get("/some-nonexistent-article")
    assert conn.status == 404
  end

  test "RSS returns OK" do
    conn = get("/feed.atom")
    assert conn.status == 200
  end
end
