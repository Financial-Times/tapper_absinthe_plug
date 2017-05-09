defmodule Tapper.Plug.Absinthe.Mixfile do
  use Mix.Project

  def project do
    [app: :tapper_absinthe_plug,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  # # Configuration for the OTP application
  # #
  # # Type "mix help compile.app" for more information
  # def application do
  #   # Specify extra applications you'll use from Erlang/Elixir
  #   [extra_applications: [:logger]]
  # end
  
  def package do
    [ maintainers: ["Ellis Pritchard"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Financial-Times/tapper_absinthe_plug"} ]
  end

  def docs do
    [main: "README",
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
      {:tapper, git: "https://github.com/Financial-Times/tapper.git"},
      {:plug, "~> 1.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev]}
    ]
  end
end