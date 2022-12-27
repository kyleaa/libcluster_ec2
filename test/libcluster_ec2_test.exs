defmodule ClusterEC2Test do
  use ExUnit.Case
  doctest ClusterEC2

  setup do
    Tesla.Mock.mock(fn
      %{
        method: :get,
        url: "http://169.254.169.254/latest/meta-data/instance-id/",
        headers: [{"X-aws-ec2-metadata-token", "test-token-foo"}]
      } ->
        %Tesla.Env{status: 200, body: "i-0fdde7ca9faef9792"}

      %{method: :get, url: "http://169.254.169.254/latest/meta-data/instance-id/"} ->
        %Tesla.Env{status: 200, body: "i-0fdde7ca9faef9751"}

      %{
        method: :get,
        url: "http://169.254.169.254/latest/meta-data/placement/availability-zone/",
        headers: [{"X-aws-ec2-metadata-token", "test-token-foo"}]
      } ->
        %Tesla.Env{status: 200, body: "eu-west-1b"}

      %{method: :get, url: "http://169.254.169.254/latest/meta-data/placement/availability-zone/"} ->
        %Tesla.Env{status: 200, body: "eu-central-1b"}

      %{
        method: :put,
        url: "http://169.254.169.254/latest/api/token",
        body: nil,
        headers: [{"X-aws-ec2-metadata-token-ttl-seconds", "21600"}]
      } ->
        %Tesla.Env{status: 200, body: "test-token-foo"}
    end)

    :ok
  end

  test "return local_instance_id" do
    assert "i-0fdde7ca9faef9751" == ClusterEC2.local_instance_id(false)
    assert "i-0fdde7ca9faef9792" == ClusterEC2.local_instance_id(true)
  end

  test "return instance_region" do
    assert "eu-central-1" == ClusterEC2.instance_region(false)
    assert "eu-west-1" == ClusterEC2.instance_region(true)
  end
end
