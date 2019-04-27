defmodule RLE.MixProject do
  use Mix.Project

  def project do
    [
      app: :rle,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end
end
