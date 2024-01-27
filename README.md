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
  [{:libcluster_ec2, "~> 0.5"}]
end
```

## AWS IAM Requirements

Instances must have an instance role attached. There are two permissions required:
* `ec2:DescribeInstances` - Required to determine tag values of the current running instance. Can be restricted by Resource to the current instance running the application
* `ec2:DescribeTags` - Required to identify other instances with the same tags 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}
```