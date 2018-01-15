defmodule ClusterEC2Test do
  use ExUnit.Case
  doctest ClusterEC2

  setup do
    Tesla.Mock.mock fn
      %{method: :get, url: "http://169.254.169.254/latest/meta-data/instance-id/"} ->
        %Tesla.Env{status: 200, body: "i-0fdde7ca9faef9751"}
      %{method: :get, url: "http://169.254.169.254/latest/meta-data/placement/availability-zone/"} ->
        %Tesla.Env{status: 200, body: "eu-central-1b"}
    end
    :ok
  end

  test "return local_instance_id" do
    assert "i-0fdde7ca9faef9751" == ClusterEC2.local_instance_id()
  end

  test "return instance_region" do
    assert "eu-central-1" == ClusterEC2.instance_region()
  end
end
