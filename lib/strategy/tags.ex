defmodule ClusterEC2.Strategy.Tags do
  @moduledoc """
  This clustering strategy works by loading all instances that have the given
  tag associated with them.

  All instances must be
      config :libcluster,
        topologies: [
          k8s_example: [
            strategy: #{__MODULE__},
            config: [

              ec2_tagname: "mytag",
              ec2_tagvalue: "tagvalue"
              ip_type: :private
              polling_interval: 10_000]]]
  """
  use GenServer
  use Cluster.Strategy
  import Cluster.Logger
  import SweetXml, only: [sigil_x: 2]

  alias Cluster.Strategy.State

  @default_polling_interval 5_000

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)
  def init(opts) do
    state = %State{
      topology: Keyword.fetch!(opts, :topology),
      connect: Keyword.fetch!(opts, :connect),
      disconnect: Keyword.fetch!(opts, :disconnect),
      config: Keyword.fetch!(opts, :config),
      meta: MapSet.new([])
    }

    {:ok, state, 0}
  end

  def handle_info(:timeout, state) do
    handle_info(:load, state)
  end
  def handle_info(:load, %State{topology: topology, connect: connect, disconnect: disconnect} = state) do
    new_nodelist = MapSet.new(get_nodes(state))
    added        = MapSet.difference(new_nodelist, state.meta)
    removed      = MapSet.difference(state.meta, new_nodelist)
    new_nodelist = case Cluster.Strategy.disconnect_nodes(topology, disconnect, MapSet.to_list(removed)) do
                :ok ->
                  new_nodelist
                {:error, bad_nodes} ->
                  # Add back the nodes which should have been removed, but which couldn't be for some reason
                  Enum.reduce(bad_nodes, new_nodelist, fn {n, _}, acc ->
                    MapSet.put(acc, n)
                  end)
              end
    new_nodelist = case Cluster.Strategy.connect_nodes(topology, connect, MapSet.to_list(added)) do
              :ok ->
                new_nodelist
              {:error, bad_nodes} ->
                # Remove the nodes which should have been added, but couldn't be for some reason
                Enum.reduce(bad_nodes, new_nodelist, fn {n, _}, acc ->
                  MapSet.delete(acc, n)
                end)
            end
    Process.send_after(self(), :load, Keyword.get(state.config, :polling_interval, @default_polling_interval))
    {:noreply, %{state | :meta => new_nodelist}}
  end
  def handle_info(_, state) do
    {:noreply, state}
  end

  @spec get_nodes(State.t) :: [atom()]
  defp get_nodes(%State{topology: topology, config: config}) do
    tag_name = Keyword.fetch!(config, :ec2_tagname)
    tag_value = Keyword.fetch!(config, :ec2_tagvalue)
    app_prefix = Keyword.fetch!(config, :app_prefix)
    cond do
      tag_name != nil and tag_value != nil and app_prefix != nil ->
        params = [filters: ["tag:#{tag_name}": fetch_tag_value(tag_name,tag_value)]]
        request = ExAws.EC2.describe_instances(params)
        require Logger
        Logger.debug "#{inspect request}"
        case ExAws.request(request) do
          {:ok, %{body: body}} ->
            body
            |> SweetXml.xpath(ip_xpath(Keyword.get(config, :ip_type, :private)))
            |> ip_to_nodename(app_prefix)
          _ ->
            []
        end
      app_prefix == nil ->
        warn topology, "ec2 tags strategy is selected, but :app_prefix is not configured!"
        []
      tag_name == nil ->
        warn topology, "ec2 tags strategy is selected, but :ec2_tagname is not configured!"
        []
      tag_value == nil ->
        warn topology, "ec2 tags strategy is selected, but :ec2_tagvalue is not configured!"
        []
      :else ->
        warn topology, "ec2 tags strategy is selected, but is not configured!"
        []
    end
  end

  defp ip_xpath(:private), do: ~x"//DescribeInstancesResponse/reservationSet/item/instancesSet/item/privateIpAddress/text()"ls
  defp ip_xpath(:public), do: ~x"//DescribeInstancesResponse/reservationSet/item/instancesSet/item/publicIpAddress/text()"ls

  defp fetch_tag_value(_k,v) when is_function(v, 0), do: v.()
  defp fetch_tag_value(k,v) when is_function(v, 1), do: v.(k)
  defp fetch_tag_value(_k,v), do: v

  def ip_to_nodename(list, app_prefix) when is_list(list) do
    list
    |> Enum.map(fn i ->
      :"#{app_prefix}@#{i}"
    end)
  end

end
