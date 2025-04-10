defmodule AOC2024.Day25 do
  def count_line(line) do
    Enum.map(line, fn c -> if c == "#", do: 1, else: 0 end)
  end

  def sum_lines(l1, l2) do
    Enum.zip(l1, l2) |> Enum.map(fn {a, b} -> a + b end)
  end

  def fits?(l1, l2) do
    Enum.zip(l1, l2) |> Enum.map(fn {a, b} -> a + b end) |> Enum.all?(fn x -> x < 8 end)
  end

  def parse(block) do
    block
    |> Enum.map(fn entry -> Enum.map(entry, fn line -> String.graphemes(line) end) end)
    |> Enum.map(fn entry ->
      Enum.reduce(entry, List.duplicate(0, 5), fn line, acc ->
        count_line(line) |> sum_lines(acc)
      end)
    end)
  end

  def part1(input) do
    blocks =
      Enum.chunk_by(input, fn line -> line == "" end)
      |> Enum.reject(fn block -> block == [""] end)

    groups = Enum.group_by(blocks, fn block -> block |> hd |> String.starts_with?("#") end)

    keys = Map.get(groups, false) |> parse()
    locks = Map.get(groups, true) |> parse()

    fitting = for k <- keys, l <- locks, do: fits?(k, l)
    fitting |> Enum.count(& &1) |> IO.inspect(label: "Part 1")
  end
end
