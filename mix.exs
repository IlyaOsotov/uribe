defmodule Uribe.MixProject do
  use Mix.Project

  def project do
    [
      app: :uribe,
      name: "Uribe",
      version: "0.2.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description,
      package: package,   
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Library for URI manipulation
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Ilya Osotov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/IlyaOsotov/uribe"}
    ]
  end
end
