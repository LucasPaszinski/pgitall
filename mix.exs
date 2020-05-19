defmodule GitAll.MixProject do
  use Mix.Project

  def project do
    [
      app: :gitall,
      version: "0.1.1",
      escript: escript_config(),
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript_config do
    [
      main_module: GitAll
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
    ]
  end
end
