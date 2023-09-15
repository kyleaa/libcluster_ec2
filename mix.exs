defmodule ClusterEC2.Mixfile do
  use Mix.Project

  def project do
    [
      app: :libcluster_ec2,
      version: "0.7.0",
      elixir: "~> 1.4",
      name: "libcluster_ec2",
      source_url: "https://github.com/kyleaa/libcluster_ec2",
      homepage_url: "https://github.com/kyleaa/libcluster_ec2",
      description: description(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:libcluster, "~> 2.0 or ~> 3.0"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_ec2, "~> 2.0"},
      {:sweet_xml, "~> 0.6"},
      {:hackney, "~> 1.18"},
      {:mox, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    EC2 clustering strategy for libcluster
    """
  end

  def package do
    [
      maintainers: ["Kyle Anderson"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/kyleaa/libcluster_ec2.git"
      }
    ]
  end
end
