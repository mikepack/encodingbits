defmodule Dynamo.ViewHelpers do
  defmacro stylesheet_link_tag(basename) do
    quote do
      %s{<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/#{unquote(basename)}.css\">}
    end
  end

  defmacro javascript_include_tag(basename) do
    quote do
      %s{<script src="/static/#{unquote(basename)}.js"></script>}
    end
  end

  defmacro link_to(name, href) do
    quote do
      %s{<a href="#{unquote(href)}">#{unquote(name)}</a>}
    end
  end
end