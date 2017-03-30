defmodule ClusterEC2 do
  alias ExAws.EC2
  import SweetXml, only: [sigil_x: 2]

  @meta_api_root "http://169.254.169.254/latest/meta-data/"

  def local_instance_tag_value(tagname), do: local_instance_tags() |> Map.get(tagname)

  def local_instance_id do
    request @meta_api_root <> "instance-id/"
  end

  def local_instance_tags do
    EC2.describe_instances([{:"instance_id.1", local_instance_id()}])
    |> ExAws.request!
    |> extract_tags
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
