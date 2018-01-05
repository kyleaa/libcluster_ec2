defmodule Strategy.Tags do
    use ExUnit.Case, async: false
    doctest ClusterEC2

    setup do
      Tesla.Mock.mock_global fn
        %{method: :get, url: "http://169.254.169.254/latest/meta-data/instance-id/"} ->
        %Tesla.Env{status: 200, body: "i-0fdde7ca9faef9751"}
        %{method: :get, url: "http://169.254.169.254/latest/meta-data/placement/availability-zone/"} ->
        %Tesla.Env{status: 200, body: "eu-central-1b"}
      end

      ops = [
        topology: ClusterEC2.Strategy.Tags,
        connect: {:net_kernel, :connect, []},
        disconnect: {:net_kernel, :disconnect, []},
        list_nodes: {:erlang, :nodes, [:connected]},
        config: [
          ec2_tagname: "elasticbeanstalk:environment-name"
        ]
      ]

      {:ok, server_pid} = ClusterEC2.Strategy.Tags.start_link(ops)
      {:ok, server: server_pid}
    end

    test "test info call :load", %{server: pid} do

      assert :load == send(pid, :load)
      assert %Cluster.Strategy.State{
        config: [ec2_tagname: "elasticbeanstalk:environment-name"],
        connect: {:net_kernel, :connect, []},
        disconnect: {:net_kernel, :disconnect, []},
        list_nodes: {:erlang, :nodes, [:connected]},
        meta: MapSet.new([]),
        topology: ClusterEC2.Strategy.Tags
      } == :sys.get_state(pid)
    end
  end
