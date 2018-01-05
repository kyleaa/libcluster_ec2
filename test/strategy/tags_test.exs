defmodule Strategy.Tags do
    use ExUnit.Case
    alias Cluster.Strategy.State
    doctest ClusterEC2

    setup do
      Tesla.Mock.mock fn
        %{method: :get, url: "http://169.254.169.254/latest/meta-data/instance-id/"} ->
        %Tesla.Env{status: 200, body: "i-0fdde7ca9faef9751"}
        %{method: :get, url: "http://169.254.169.254/latest/meta-data/placement/availability-zone/"} ->
        %Tesla.Env{status: 200, body: "eu-central-1b"}
      end

      ops = %State{
        topology: ClusterEC2.Strategy.Tags,
        config: [
          ec2_tagname: "elasticbeanstalk:environment-name"
        ],
        connect: [],
        disconnect: [],
        list_nodes: {:erlang, :nodes, [:connected]},
        meta: MapSet.new([])
      }
      {:ok, server_pid} = ClusterEC2.Strategy.Tags.start_link(ops)
      {:ok, server: server_pid}
    end

    test "the truth", %{server: pid} do
      ops = %State{
        topology: ClusterEC2.Strategy.Tags,
        config: [
          ec2_tagname: "elasticbeanstalk:environment-name"
        ],
        connect: [],
        disconnect: [],
        list_nodes: {:erlang, :nodes, [:connected]},
        meta: MapSet.new([])
      }

      IO.inspect GenServer.call(pid, {:load, ClusterEC2.Strategy.Tags.init(ops)})

      assert 1 == 1
    end
  end
