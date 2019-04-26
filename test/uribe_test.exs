defmodule UribeTest do
  use ExUnit.Case
  doctest Uribe

  test "adding query" do
    uri = URI.parse("https://google.com") |> Uribe.add_query(%{"foo" => "bar"})

    uri.query == "foo=bar"
  end
end
