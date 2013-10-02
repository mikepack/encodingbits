defmodule Dynamo.ViewHelpersTest do
  use ExUnit.Case
  require Dynamo.ViewHelpers

  test "#stylesheet_link_tag" do
    assert Dynamo.ViewHelpers.stylesheet_link_tag("file") == %S{<link rel="stylesheet" type="text/css" href="/static/file.css">}
  end

  test "#javascript_include_tag" do
    assert Dynamo.ViewHelpers.javascript_include_tag("file") == %S{<script src="/static/file.js"></script>}
  end
end