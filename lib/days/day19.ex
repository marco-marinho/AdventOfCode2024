defmodule AOC2024.Day19 do
  def dfs(left, _, visited) when left == "" do
    {1, visited}
  end

  def dfs(left, parts, cache) do
    case cache do
      %{^left => nsols} ->
        {nsols, cache}

      _ ->
        {solutions, cache} =
          parts
          |> Enum.filter(fn part -> String.starts_with?(left, part) end)
          |> Enum.reduce({0, cache}, fn part, {sol_acc, cache_acc} ->
            new_left = String.slice(left, byte_size(part)..-1//1)
            {nsols, ncache} = dfs(new_left, parts, cache_acc)
            {sol_acc + nsols, ncache}
          end)

        {solutions, Map.put(cache, left, solutions)}
    end
  end

  def solve(input) do
    parts = hd(input) |> String.split(", ")
    targets = Enum.drop(input, 2)

    targets
    |> Enum.map(fn target ->
      dfs(target, parts, Map.new()) |> elem(0)
    end)
  end

  def part1(input) do
    solve(input)
    |> Enum.count(fn x -> x != 0 end)
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    solve(input)
    |> Enum.sum()
    |> IO.inspect(label: "Part 2")
  end
end
