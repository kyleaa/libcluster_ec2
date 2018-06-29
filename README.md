ClusterEC2
==========

This is an EC2 clustering strategy for  [libcluster](https://hexdocs.pm/libcluster/). It currently supports identifying nodes based on EC2 tags.

The default `Tags` strategy uses [ex_aws](https://github.com/ex-aws/ex_aws) to query the EC2 DescribeInstances API endpoint. Access to this API should be granted to the EC2 instance profile. See the ExAws docs for additional configuration options.

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
  [{:libcluster_ec2, "~> 0.4"}]
end
```
