defmodule ClusterEC2 do
  @moduledoc File.read!("#{__DIR__}/../README.md")

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """

  require Logger

  @spec local_instance_id() :: binary()
  def local_instance_id do
    case get_metadata("/instance-id/") do
      {:ok, id} -> id
      {:error, _} -> ""
    end
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region() :: binary()
  def instance_region do
    case get_metadata("/placement/availability-zone/") do
      {:ok, az} -> String.slice(az, 0..-2//1)
      {:error, _} -> ""
    end
  end

  defp get_metadata(path) do
    try do
      meta =
        ExAws.Config.new(:ec2)
        |> ExAws.InstanceMeta.request("http://169.254.169.254/latest/meta-data#{path}")

      {:ok, meta}
    rescue
      e ->
        Logger.warn("Error fetching metadata: #{inspect(e)}")
        {:error, e}
    end
  end
end
