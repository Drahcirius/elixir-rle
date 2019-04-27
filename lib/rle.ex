defmodule RLE do
  @moduledoc """
  Documentation for run length encoder.
  """

  @doc """
  Encodes a binary using run-length encoding. The number of bytes for each run can be specified as the second parameter


  ## Examples

      iex> RLE.encode("aaaabb")
      [{4, "a"}, {2, "b"}]
      iex> RLE.encode("aaaabb", 2)
      [{2, "aa"}, {1, "bb"}]

  """
  @spec encode(String.t(), number) :: [{number, String.t()}]
  def encode(bin, bytes_number \\ 1) do
    case bin do
      <<char::binary-size(bytes_number), rest::binary>> ->
        encode(rest, bytes_number, char, 1, [])

      bytes ->
        [{1, bytes}]
    end
  end

  @doc """
  Decodes a run-length encoded list to return the original binary.

  ## Examples

      iex> RLE.decode([{4, "a"}, {2, "b"}])
      "aaaabb"
  """
  @spec decode([{number, String.t()}]) :: String.t()
  def decode(list) do
    list
    |> Enum.map(fn {repeat, bytes} -> String.duplicate(bytes, repeat) end)
    |> IO.iodata_to_binary()
  end

  defp encode(bin, num, curr, count, stack) do
    case bin do
      <<^curr::binary-size(num), rest::binary>> ->
        encode(rest, num, curr, count + 1, stack)

      <<char::binary-size(num), rest::binary>> ->
        encode(rest, num, char, 1, [{count, curr} | stack])

      "" ->
        Enum.reverse([{count, curr} | stack])

      char ->
        Enum.reverse([{1, char}, {count, curr} | stack])
    end
  end
end
