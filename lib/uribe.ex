defmodule Uribe do
  @moduledoc """
  Documentation for Uribe.
  Uribe always receives URI in the first argument and always returns URI
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

      iex> uri = URI.parse("https://google.com/bar?baz=qux") |> Uribe.cut("/foo")
      iex> URI.to_string(uri)
      "https://google.com/foo"

  """
  def cut(uri, path) do
    %{ uri | path: path, query: nil }
  end

  defp query_to_enum(query) do
    (query || "") |> URI.query_decoder |> Enum.into(%{})
  end
end
