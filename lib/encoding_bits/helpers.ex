defmodule EncodingBits.Helpers do
  use Dynamo.Helpers

  defmacro page_title do
    quote do
      title content_for(:title)
    end
  end

  def title(content) when is_bitstring(content) do
    " - #{content}"
  end

  def title(content) do
    ""
  end
end