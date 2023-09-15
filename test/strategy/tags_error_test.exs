defmodule Strategy.TagsErrorTest do
  use ExUnit.Case, async: false
  doctest ClusterEC2

  import Mox
  setup :verify_on_exit!
  setup :set_mox_from_context

  test "test info call :load" do
    ClusterEC2Mock
    |> stub(:local_instance_id, fn ->
      "i-0fdde7ca9faef9751"
    end)
    |> stub(:instance_region, fn ->
      "eu-central-1b"
    end)

    ClusterEC2.HTTPClientMock
    |> stub(:request, fn _, _, _, _, _ ->
      {:ok, body} = File.read("test/fixtures/ec2_metadata.xml")

      {:ok, %{status_code: 200, headers: [], body: body}}
    end)

    ops = [
      topology: ClusterEC2.Strategy.Tags,
      connect: {:net_kernel, :connect, []},
      disconnect: {:net_kernel, :disconnect, []},
      list_nodes: {:erlang, :nodes, [:connected]},
      config: [
        ec2_tagname: "elasticbeanstalk:environment-name"
      ]
    ]

    {:ok, pid} = ClusterEC2.Strategy.Tags.start_link(ops)

    assert :load == send(pid, :load)

    assert %Cluster.Strategy.State{
             config: [ec2_tagname: "elasticbeanstalk:environment-name"],
             connect: {:net_kernel, :connect, []},
             disconnect: {:net_kernel, :disconnect, []},
             list_nodes: {:erlang, :nodes, [:connected]},
             meta: MapSet.new([]),
             topology: ClusterEC2.Strategy.Tags
           } == :sys.get_state(pid)

    Process.exit(pid, :kill)
  end
end
