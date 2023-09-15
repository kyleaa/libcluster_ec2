defmodule ClusterEC2.HTTPClient do
  @callback request(
              method :: atom,
              url :: binary(),
              body :: String.t(),
              headers :: [{String.t(), String.t()}],
              http_opts :: [any]
            ) ::
              {:ok, integer, [{String.t(), String.t()}], String.t()}
              | {:ok, integer, [{String.t(), String.t()}]}
              | {:error, any}

  @callback get(url :: binary(), headers :: [{String.t(), String.t()}], http_opts :: [any]) ::
              {:ok, integer, [{String.t(), String.t()}], String.t()}
              | {:ok, integer, [{String.t(), String.t()}]}
              | {:error, any}

  @callback body(ref :: any()) :: {:ok, String.t()} | {:error, any}

  def get(url, headers \\ [], http_opts \\ []) do
    http_client_module().get(url, headers, http_opts)
  end

  def body(ref) do
    http_client_module().body(ref)
  end

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    http_client_module().request(method, url, headers, body, http_opts)
  end

  def http_client_module do
    Application.get_env(:libcluster_ec2, :http_client, :hackney)
  end
end
