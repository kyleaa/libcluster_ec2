ClusterEC2
==========

This is an EC2 clustering strategy for  [libcluster](https://hexdocs.pm/libcluster/). It currently supports identifying nodes based on EC2 tags.

```
config :libcluster,
  topologies: [
    example: [
      strategy: ClusterEC2.Strategy.Tags,
      config: [
        ec2_tagname: "elasticbeanstalk:environment-name"
      ],
    ]
  ]
```

## Installation

The package can be installed
by adding `libcluster_ec2` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:libcluster_ec2, "~> 0.1.0"}]
end
```
