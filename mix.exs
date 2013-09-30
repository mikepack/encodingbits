defmodule EncodingBits.Mixfile do
  use Mix.Project

  def project do
    [ app: :encoding_bits,
      version: "0.0.1",
      dynamos: [EncodingBits.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/encoding_bits/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { EncodingBits, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      { :ex_doc, github: "elixir-lang/ex_doc" } ]
  end
end
