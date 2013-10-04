Dynamo.under_test(EncodingBits.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule EncodingBits.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
  end
end
