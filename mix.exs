defmodule HrStars.MixProject do
  use Mix.Project

  def project do
    [
      app: :hr_stars,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HrStars.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.10.0"},
      {:floki, "~> 0.26.0"}
    ]
  end
end
