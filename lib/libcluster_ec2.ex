defmodule ClusterEC2 do

  @moduledoc File.read!("#{__DIR__}/../README.md")

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  @spec local_instance_id() :: binary()
  def local_instance_id, do: get_metadata("/instance-id/")

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region() :: binary()
  def instance_region do
    get_metadata("/placement/availability-zone/")
    |> String.slice(0..-2//1)
  end

  defp get_metadata(path) do
    ExAws.Config.new(:ec2)
    |> ExAws.InstanceMeta.request("http://169.254.169.254/latest/meta-data#{path}")
  end
end
