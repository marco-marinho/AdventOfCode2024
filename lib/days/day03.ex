defmodule AOC2024.Day03 do
  def part1(input) do
    regex = ~r/mul\((\d+),(\d+)\)/
    input = Enum.join(input, "")
    valid = Regex.scan(regex, input)

    valid
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
    |> IO.inspect(label: "Part 1")
  end

  def maybe_mul(match, enabled, acc) do
    result =
      case match do
        ["do()"] ->
          {true, acc}

        ["don't()"] ->
          {false, acc}

        [_, v1, v2] ->
          if enabled do
            {true, acc + String.to_integer(v1) * String.to_integer(v2)}
          else
            {false, acc}
          end
      end

    result
  end

  def part2(input) do
    regex = ~r/(?:mul\((\d+),(\d+)\))|(?:do\(\))|(?:don't\(\))/
    input = Enum.join(input, "")
    valid = Regex.scan(regex, input)

    {_, ans} =
      Enum.reduce(valid, {true, 0}, fn line, {enabled, acc} ->
        maybe_mul(line, enabled, acc)
      end)

    ans |> IO.inspect(label: "Part 2")
  end
end
