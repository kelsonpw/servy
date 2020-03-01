defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of header fields into a map" do
    headers = ["Type: Dog", "Color: Blue", "Size: Large"]

    parsed = Parser.parse_headers(headers, %{})

    assert parsed == %{"Type" => "Dog", "Color" => "Blue", "Size" => "Large"}
  end
end
