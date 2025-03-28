defmodule AOC2024.Day07 do
  def operators1(a, b) do
    [
      a + b,
      a * b
    ]
  end

  def operators2(a, b) do
    [
      a + b,
      a * b,
      String.to_integer("#{a}#{b}")
    ]
  end

  def calculate(head, tail, operators) do
    if Enum.empty?(tail) do
      head
    else
      [b | rest] = tail

      next_head =
        Enum.reduce(head, [], fn a, acc ->
          operators.(a, b) ++ acc
        end)

      calculate(next_head, rest, operators)
    end
  end

  def parse(input) do
    Enum.map(input, &String.split(&1, ": "))
    |> Enum.map(fn [a, b] ->
      [String.to_integer(a), String.split(b, " ") |> Enum.map(&String.to_integer/1)]
    end)
  end

  def solve(input, operator, label) do
    parse(input)
    |> Task.async_stream(fn [target, [head | tail]] ->
      case Enum.member?(calculate([head], tail, operator), target) do
        true -> target
        false -> 0
      end
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
    |> IO.inspect(label: label)
  end

  def part1(input) do
    solve(input, &operators1/2, "Part 1")
  end

  def part2(input) do
    solve(input, &operators2/2, "Part 2")
  end
end
