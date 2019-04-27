# RLE

Run-length encoding implementation in Elixir. Use RLE.Bit for bitmaps. 

Runs are represented as a list of tuples. 

## Examples

### Byte run-lengths
```elixir
iex> RLE.encode("aaaabb")
[{4, "a"}, {2, "b"}]

iex> RLE.encode("aaaabb", 2)
[{2, "aa"}, {1, "bb"}]

iex> RLE.decode([{4, "a"}, {2, "b"}])
"aaaabb"
```

### Bitmap run-lengths
```elixir
iex> RLE.Bit.encode(<<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>)
[160]

iex> RLE.Bit.encode(<<1::size(1),0,0,0,0,0,0,0,0>>)
[0, 1, 64]

iex> RLE.Bit.encode(<<1::size(1),0::size(7)>>) |> RLE.Bit.decode
<<128>>

iex> RLE.Bit.decode([7, 1, 64])
<<1, 0, 0, 0, 0, 0, 0, 0, 0>>
```

### Serializing encodings
This library does not serialize the encodings to binary, so if the runs need to be serialized to binary for external storage use etf
```elixir
serialized = <<0 :: size(1000)>> |> RLE.Bit.encode() |> :erlang.term_to_binary

unserialized = serialized |> :erlang.binary_to_term |> RLE.Bit.decode()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rle, "~> 0.1.0"}
  ]
end
```
