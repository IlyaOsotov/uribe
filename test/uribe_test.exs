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

  test "manipulating with URI" do
    uri = URI.parse("https://google.com")
          |> Uribe.toggle_scheme
          |> Uribe.host("localhost")
          |> Uribe.port(4000)
          |> Uribe.path("/foo")
          |> Uribe.add_query(%{"bar" => "baz"})
          |> Uribe.fragment("qux")

    assert URI.to_string(uri) == "http://localhost:4000/foo?bar=baz#qux"
  end
end
