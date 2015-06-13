defmodule DofusNext.Mixfile do
  use Mix.Project

  def project do
    [app:             :dofus_next,
     version:         "0.0.1",
     elixir:          "~> 1.0",
     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps:            deps(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: application(Mix.env),
     mod:          {DofusNext, []},
     registered:   []]
  end

  defp application(:prod) do
    ~w(logger)a
  end

  defp application(:dev) do
    ~w()a ++ application(:prod)
  end

  defp application(:test) do
    ~w()a ++ application(:prod)
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps(:prod) do
    [{:ranch,    "~> 1.0"},
     {:ecto,     "~> 0.11.3"},
     {:postgrex, "~> 0.8.0"}]
  end

  defp deps(:dev) do
    deps(:prod) ++ [

    ]
  end

  defp deps(:test) do
    deps(:test) ++ [

    ]
  end
end
