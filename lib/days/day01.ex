defmodule AOC2024.Day01 do
  def parse(input) do
    input
    |> Enum.map(fn str -> String.replace(str, ~r/\s+/, " ") end)
    |> Enum.map(fn str -> String.split(str, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sort/1)
  end

  def part1(input) do
    data = parse(input)
    Enum.zip(data) |> Enum.map(fn {v1, v2} -> Kernel.abs(v1 - v2) end) |> Enum.sum() |> IO.inspect()
  end

  def part2(input) do
    data = parse(input)
    [f1, f2] = data |> Enum.map(&Enum.frequencies/1)
    Enum.map(f1, fn {k, v} -> k * v * Map.get(f2, k, 0) end) |> Enum.sum() |> IO.inspect()
  end
end
