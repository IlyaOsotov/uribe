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

      iex> uri = URI.parse("https://google.com?foo=bar") |> Uribe.add_query(%{"foo" => "baz"})
      iex> uri.query
      "foo=baz"

  """
  def add_query(uri, query) do
    uri_query = (uri.query || "") |> URI.query_decoder |> Enum.into(%{}) |> Map.merge(query)
    %{ uri | query: URI.encode_query(uri_query) }
  end

  @doc """
  Remove param from URI query

  ## Examples

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove_param("foo")
      iex> uri.query
      "baz=foo"

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove_param("baz")
      iex> uri.query
      "foo=bar"

      iex> uri = URI.parse("https://google.com?foo=bar&baz=foo") |> Uribe.remove_param("baz") |> Uribe.remove_param("foo")
      iex> uri.query
      ""

  """
  def remove_param(uri, param) do
    query = uri.query |> URI.query_decoder |> Enum.into(%{}) |> Map.delete(param)
    
    %{ uri | query: URI.encode_query(query) }
  end
end
