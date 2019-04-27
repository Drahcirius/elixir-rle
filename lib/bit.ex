defmodule RLE.Bit do
  @moduledoc """
  Documentation for binary run length encoder. This is mainly meant for bitmaps rather than strings.
  """

  @doc """
  Encodes a bitmap using run-length encoding.

  ## Examples

      iex> RLE.Bit.encode(<<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>)
      [160]
      iex> RLE.Bit.encode(<<1::size(1),0,0,0,0,0,0,0,0>>)
      [0, 1, 64]
  """
  def encode(bits) do
    encode(bits, 0, 0, [])
  end

  @doc """
  Decodes a run-length encoded list to the original binary

  ## Examples

      iex> RLE.Bit.encode(<<1::size(1),0::size(7)>>) |> RLE.Bit.decode
      <<128>>
      iex> RLE.Bit.decode([7, 1, 64])
      <<1, 0, 0, 0, 0, 0, 0, 0, 0>>
  """
  def decode(list) do
    decode(list, 0, <<>>)
  end

  defp encode(<<0::size(1), rest::bits>>, 0, counter, stack) do
    encode(rest, 0, counter + 1, stack)
  end

  defp encode(<<1::size(1), rest::bits>>, 0, counter, stack) do
    encode(rest, 1, 1, [counter | stack])
  end

  defp encode(<<1::size(1), rest::bits>>, 1, counter, stack) do
    encode(rest, 1, counter + 1, stack)
  end

  defp encode(<<0::size(1), rest::bits>>, 1, counter, stack) do
    encode(rest, 0, 1, [counter | stack])
  end

  defp encode(<<>>, _, counter, stack) do
    Enum.reverse([counter | stack])
  end

  defp decode([head | rest], 0, acc) do
    decode(rest, 1, <<acc::bitstring, <<0::size(head)>>::bitstring>>)
  end

  defp decode([head | rest], 1, acc) do
    decode(rest, 0, <<acc::bitstring, <<:erlang.bsl(1, head) - 1::size(head)>>::bitstring>>)
  end

  defp decode([], _, acc) do
    acc
  end
end
