defmodule ClusterEC2Test do
  use ExUnit.Case
  doctest ClusterEC2

  import Mox
  setup :verify_on_exit!

  test "return local_instance_id" do
    ClusterEC2.HTTPClientMock
    |> expect(:get, fn "http://169.254.169.254/latest/meta-data/instance-id/", _headers, _http_opts ->
      {:ok, 200, [], "instance-id-ref"}
    end)
    |> expect(:body, fn "instance-id-ref" ->
      {:ok, "i-0fdde7ca9faef9751"}
    end)

    assert "i-0fdde7ca9faef9751" == ClusterEC2.local_instance_id()
  end

  test "return instance_region" do
    ClusterEC2.HTTPClientMock
    |> expect(:get, fn "http://169.254.169.254/latest/meta-data/availability-zone/", _headers, _http_opts ->
      {:ok, 200, [], "availability-zone-ref"}
    end)
    |> expect(:body, fn "availability-zone-ref" ->
      {:ok, "eu-central-1b"}
    end)

    assert "eu-central-1" == ClusterEC2.instance_region()
  end
end
