defmodule EncodingBits.Helpers do
  use Dynamo.Helpers

  defmacro page_title do
    quote do
      title content_for(:title)
    end
  end

  defmacro datetime(article) do
    quote do
      a = unquote(article)
      "#{a[:year]}-#{String.rjust(to_string(a[:month]), 2, ?0)}-#{String.rjust(to_string(a[:day]), 2, ?0)}T00:00:00-07:00"
    end
  end

  def title(content) when is_bitstring(content) do
    " - #{content}"
  end
  def title(_) do "" end
end