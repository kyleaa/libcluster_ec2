defmodule ClusterEC2 do
  use Tesla

  @moduledoc File.read!("#{__DIR__}/../README.md")

  plug(Tesla.Middleware.BaseUrl, "http://169.254.169.254/latest")

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  @spec local_instance_id(use_imds_v2 :: boolean()) :: binary()
  def local_instance_id(true) do
    with token when token != "" <- get_token(),
         body <- get_body("/meta-data/instance-id/", [{"X-aws-ec2-metadata-token", token}]) do
      body
    end
  end

  def local_instance_id(false) do
    with body <- get_body("/meta-data/instance-id/") do
      body
    end
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region(use_imds_2 :: boolean()) :: binary()
  def instance_region(true) do
    with token when token != "" <- get_token(),
         body <- get_body("/meta-data/placement/availability-zone/", [{"X-aws-ec2-metadata-token", token}]) do
      String.slice(body, 0..-2)
    end
  end

  def instance_region(false) do
    with body <- get_body("/meta-data/placement/availability-zone/") do
      String.slice(body, 0..-2)
    end
  end

  defp get_body(url, headers \\ []) do
    case get(url, headers: headers) do
      {:ok, %{status: 200, body: body}} -> body
      _ -> ""
    end
  end

  defp get_token do
    case put("/api/token", nil, headers: [{"X-aws-ec2-metadata-token-ttl-seconds", "21600"}]) do
      {:ok, %{status: 200, body: body}} -> body
      _ -> ""
    end
  end
end
