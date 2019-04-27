defmodule UribeTest do
  use ExUnit.Case
  doctest Uribe

  test "adding query" do
    uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"})

    assert uri.query == "foo=bar"
  end

  test "adding query to existing query" do
    uri = URI.parse("https://google.com?baz=foo") |> Uribe.add_query(%{"foo" => "bar"})

    assert uri.query == "baz=foo&foo=bar"
  end
end
