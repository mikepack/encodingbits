defmodule Mix.Tasks.Publish do
  @moduledoc "Static publishing tasks."

  def run(_) do
    IO.puts "Publishing..."
    EncodingBits.Publisher.publish
  end

  defmodule Update do
    @moduledoc "Update existing articles without changing published date."

    def run(_) do
      IO.puts "Updating..."
      EncodingBits.Publisher.update_existing
    end
  end
end