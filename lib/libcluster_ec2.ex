defmodule ClusterEC2 do
  use Tesla

  @moduledoc File.read!("#{__DIR__}/../README.md")

  plug(Tesla.Middleware.BaseUrl, "http://169.254.169.254/latest/meta-data")

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  @spec local_instance_id() :: binary()
  def local_instance_id do
    case get("/instance-id/") do
      {:ok, %{status: 200, body: body}} -> body
      _ -> ""
    end
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region() :: binary()
  def instance_region do
    case get("/placement/availability-zone/") do
      {:ok, %{status: 200, body: body}} -> String.slice(body, 0..-2)
      _ -> ""
    end
  end
end
