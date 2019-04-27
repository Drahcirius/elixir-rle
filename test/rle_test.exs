defmodule RLETest do
  use ExUnit.Case
  doctest RLE

  test "check that input matches the output" do
    str = "string to encode using RLE"
    assert str |> RLE.encode() |> RLE.decode() == str

    assert str |> RLE.Bit.encode() |> RLE.Bit.decode() == str
  end

  test "check encoding with higher bytes work correctly" do
    assert RLE.encode("eeee", 2) == [{2, "ee"}]
    assert RLE.encode("eeeee", 2) == [{2, "ee"}, {1, "e"}]
  end

  test "check bitmaps that start with 1 encode starting with 0" do
    bitmap = <<1::size(1), 0::size(7)>>
    assert RLE.Bit.encode(bitmap) == [0, 1, 7]
  end

  test "check bitmaps encode large amounts of 0s" do
    bitmap = <<0::size(800)>>
    assert RLE.Bit.encode(bitmap) == [800]
    assert RLE.Bit.decode([800]) == bitmap
  end

  test "check edge cases" do
    assert RLE.Bit.encode(<<>>) == [0]
    assert RLE.Bit.decode([0]) == <<>>

    assert RLE.encode(<<>>) == [{1, ""}]
    assert RLE.decode([{1, ""}]) == ""
  end
end
