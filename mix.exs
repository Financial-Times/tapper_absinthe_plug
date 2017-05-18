defmodule Tapper.Plug.Absinthe.Mixfile do
  use Mix.Project

  def project do
    [app: :tapper_absinthe_plug,
     version: "0.2.0-rc",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: :project],
     name: "Tapper Absinthe Plug",
     description: description(),
     source_url: "https://github.com/Financial-Times/tapper_absinthe_plug",
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  # # Configuration for the OTP application
  # #
  # # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [applications: [:tapper], extra_applications: [:logger]]
  end

  def description do
    """
    Works in concert with Tapper.Plug to propagate the Tapper Id into the Absinthe context.
    """
  end

  def package do
    [
      maintainers: ["Ellis Pritchard"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Financial-Times/tapper_absinthe_plug"}
    ]
  end

  def docs do
    [main: "readme",
     extras: ["README.md"]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:absinthe, "~> 1.3.0"},
      # {:tapper, "~> 0.1"},
      {:tapper, github: "Financial-Times/tapper"},
      {:plug, "~> 1.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev]},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end
end
