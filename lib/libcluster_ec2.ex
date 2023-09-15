defmodule ClusterEC2 do
  alias ClusterEC2.HTTPClient

  @moduledoc File.read!("#{__DIR__}/../README.md")
  @base_url "http://169.254.169.254/latest/meta-data"

  @callback local_instance_id() :: binary()
  @callback instance_region() :: binary()

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  @spec local_instance_id() :: binary()
  def local_instance_id do
    with {:ok, 200, _headers, ref} <- HTTPClient.get(@base_url <> "/instance-id/"),
         {:ok, instance_id} <- HTTPClient.body(ref) do
      instance_id
    else
      _ -> ""
    end
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region() :: binary()
  def instance_region do
    with {:ok, 200, _headers, ref} <- HTTPClient.get(@base_url <> "/placement/availability-zone/"),
         {:ok, az} <- HTTPClient.body(ref) do
      String.slice(az, 0..-2)
    else
      _ -> ""
    end
  end
end
