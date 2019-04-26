defmodule Uribe do
  @moduledoc """
  Documentation for Uribe.
  """

  @doc """
  Adding query to URI

  ## Examples

      iex> uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"})
      iex> uri.query
      "foo=bar"

  """
  def add_query(uri, query) do
    %{ uri | query: URI.encode_query(query) }
  end
end
