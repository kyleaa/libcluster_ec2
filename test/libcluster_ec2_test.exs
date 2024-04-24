defmodule ClusterEC2Test do
  use ExUnit.Case
  alias ClusterEC2

  test "local_instance_id" do
    assert ClusterEC2.local_instance_id() == ""
  end

  test "instance_region" do
    assert ClusterEC2.instance_region() == ""
  end
end
