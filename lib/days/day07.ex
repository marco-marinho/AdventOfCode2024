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
    case tail do
      [] -> head

      [b | rest] ->
        next_head =
          Enum.reduce(head, [], fn a, acc ->
            Enum.reduce(operators.(a, b), acc, fn el, acc2 ->
              [el | acc2]
            end)
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
    |> Task.async_stream(
      fn [target, [head | tail]] ->
        case Enum.member?(calculate([head], tail, operator), target) do
          true -> target
          false -> 0
        end
      end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
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
