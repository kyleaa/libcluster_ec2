defmodule ClusterEC2 do

  @moduledoc File.read!("#{__DIR__}/../README.md")

  alias ExAws.EC2
  import SweetXml, only: [sigil_x: 2]

  @meta_api_root "http://169.254.169.254/latest/meta-data/"

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  def local_instance_id do
    request(@meta_api_root <> "instance-id/")
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  def instance_region do
    request(@meta_api_root <> "placement/availability-zone/")
    |> String.slice(0..-2)
  end

  @doc """
    Uses the EC2 API to determine the tags of the current instance.
  """
  def local_instance_tags do
    EC2.describe_instances(instance_id: local_instance_id())
    |> ExAws.request!(region: instance_region())
    |> extract_tags
  end

  @doc """
    Retrieves the value of a specific tag for the current instance.
  """
  def local_instance_tag_value(tagname) do
    local_instance_tags()
    |> Map.get(tagname)
  end

  defp extract_tags(%{body: xml}) do
    xml
    |> SweetXml.xpath(~x"//DescribeInstancesResponse/reservationSet/item/instancesSet/item/tagSet/item"l,
      key: ~x"./key/text()"s,
      value: ~x"./value/text()"s
    )
    |> Stream.map(fn %{key: k, value: v} -> {k,v} end)
    |> Enum.into(%{})
  end

  defp request(url) do
    case :hackney.request(:get, url, [], "", [:with_body]) do
      {:ok, 200, _headers, body} -> body
    end
  end
end
