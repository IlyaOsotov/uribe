defmodule Uribe do
  @moduledoc """
  Documentation for Uribe.
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

  defp query_to_enum(query) do
    (query || "") |> URI.query_decoder |> Enum.into(%{})
  end
end
