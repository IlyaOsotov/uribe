defmodule Uribe do
  @moduledoc """
  URI builder for Elixir.
  Uribe always receives URI struct in the first argument and always returns URI struct instead of `value` method
  """

  @doc """
  Add query to URI

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"})
      iex> uri.query
      "foo=bar"

      iex> uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"}) |> Uribe.add_query(%{"foo" => "baz"})
      iex> uri.query
      "foo=baz"

      iex> uri = URI.parse("https://google.com?foo=bar") |> Uribe.add_query(%{"foo" => "baz", "bar" => "baz"})
      iex> uri.query
      "bar=baz&foo=baz"

  """
  def add_query(uri, query) do
    uri_query = query_to_enum(uri.query) |> Map.merge(query)
    %{ uri | query: URI.encode_query(uri_query) }
  end

  @doc """
  Remove param from URI query

  ## Examples

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove("foo")
      iex> uri.query
      "baz=foo"

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove("baz")
      iex> uri.query
      "foo=bar"

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove(["baz", "foo"])
      iex> uri.query
      ""

  """
  def remove(uri, param) when is_binary(param) do
    query = query_to_enum(uri.query) |> Map.delete(param)
    
    %{ uri | query: URI.encode_query(query) }
  end

  def remove(uri, params) when is_list(params) do
    query = query_to_enum(uri.query) |> Map.drop(params)
    
    %{ uri | query: URI.encode_query(query) }
  end

  @doc """
  Set path for URI

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.path("/foo/bar")
      iex> uri.path
      "/foo/bar"

      iex> uri = URI.parse("https://google.com/bar") |> Uribe.path("/foo")
      iex> URI.to_string(uri)
      "https://google.com/foo"

  """
  def path(uri, path) do
    %{ uri | path: path }
  end

  @doc """
  Remove the entire path, query and set path

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.cut("/foo/bar")
      iex> uri.path
      "/foo/bar"

      iex> uri = URI.parse("https://google.com#qux") |> Uribe.cut("/foo/bar")
      iex> URI.to_string(uri)
      "https://google.com/foo/bar"

      iex> uri = URI.parse("https://google.com/bar?baz=qux#quux") |> Uribe.cut("/foo")
      iex> URI.to_string(uri)
      "https://google.com/foo"

  """
  def cut(uri, path) do
    %{ uri | path: path, query: nil, fragment: nil }
  end

  @doc """
  Set port for URI. Receives only integer

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.port(9292)
      iex> uri.port
      9292

  """
  def port(uri, port) when is_integer(port) do
    %{ uri | port: port }
  end

  @doc """
  Toggle `http/https` scheme for URI. If current scheme is nil or another, set `https`

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.toggle_scheme
      iex> uri.scheme
      "http"

      iex> uri = URI.parse("http://google.com") |> Uribe.toggle_scheme
      iex> uri.scheme
      "https"

      iex> uri = URI.parse("google.com") |> Uribe.toggle_scheme
      iex> uri.scheme
      "https"

  """
  def toggle_scheme(uri) do
    case uri.scheme do
      "https" -> %{ uri | scheme: "http" }
      _ -> %{ uri | scheme: "https" }
    end
  end

  @doc """
  Set host for URI

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.host("yandex.ru")
      iex> uri.host
      "yandex.ru"

      iex> uri = URI.parse("http://google.com") |> Uribe.host("localhost")
      iex> uri.host
      "localhost"

      iex> uri = URI.parse("google.com") |> Uribe.host("")
      iex> uri.host
      ""

  """
  def host(uri, host) when is_binary(host) do
    %{ uri | host: host }
  end

  @doc """
  Set fragment for URI

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.fragment("foo")
      iex> uri.fragment
      "foo"

      iex> uri = URI.parse("http://google.com") |> Uribe.fragment(nil)
      iex> uri.fragment
      nil

      iex> uri = URI.parse("google.com") |> Uribe.fragment("")
      iex> uri.fragment
      ""

  """
  def fragment(uri, fragment) do
    %{ uri | fragment: fragment }
  end

  @doc """
  Get value of query param. Returns nil if not exists

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar", "baz" => "qux"})
      iex> Uribe.value(uri, "baz")
      "qux"

      iex> uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"})
      iex> Uribe.value(uri, "baz")
      nil

      iex> URI.parse("https://google.com") |> Uribe.value("foo")
      nil

  """
  def value(uri, param) do
    query_to_enum(uri.query) |> Map.get(param)
  end

  defp query_to_enum(query) do
    (query || "") |> URI.query_decoder |> Enum.into(%{})
  end
end
