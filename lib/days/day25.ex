defmodule AOC2024.Day25 do

  def is_hash?(c) do
  case c do
    "#" -> 1
    _ -> 0
  end
  end

  def count_line(line) do
    Enum.map(line, fn c -> is_hash?(c) end) |> List.to_tuple()
  end

  def sum_lines({a, b, c, d, e}, {f, g, h, i, j}) do
    {a + f, b + g, c + h, d + i, e + j}
  end

  def fits?({a, b, c, d, e}, {f, g, h, i, j}) do
    if a+f < 8 and b+g < 8 and c+h < 8 and d+i < 8 and e+j < 8 do
     1
    else
     0
    end
  end

  def part1(input) do
    blocks = Enum.chunk_by(input, fn line -> line == "" end) |> Enum.reject(fn block -> block == [""] end)
    groups =  Enum.group_by(blocks, fn block -> block |> hd |> String.starts_with?("#") end)
    keys = Map.get(groups, false) |> Enum.map(fn block -> Enum.map(block, fn line -> String.graphemes(line) end)  end)
    locks = Map.get(groups, true) |> Enum.map(fn block -> Enum.map(block, fn line -> String.graphemes(line) end)  end)
    keys_count = Enum.map(keys, fn block -> Enum.reduce(block, {0, 0, 0, 0, 0}, fn line, acc -> count_line(line) |> sum_lines(acc) end) end)
    locks_count = Enum.map(locks, fn block -> Enum.reduce(block, {0, 0, 0, 0, 0}, fn line, acc -> count_line(line) |> sum_lines(acc) end) end)
    fitting = for k <- keys_count, l <- locks_count, do: fits?(k, l)
    fitting |> Enum.sum() |> IO.inspect(label: "Part 1")
  end

end
