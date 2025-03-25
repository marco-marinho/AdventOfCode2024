defmodule AOC2024.Day02 do
  def parse(input) do
    input
    |> Enum.map(fn str -> String.replace(str, ~r/\s+/, " ") end)
    |> Enum.map(fn str -> String.split(str, " ") |> Enum.map(&String.to_integer/1) end)
  end

  def diff(l1) do
    l1 |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [v1, v2] -> v1 - v2 end)
  end

  def all_positive(l) do
    l |> Enum.all?(fn i -> i > 0 end)
  end

  def all_negative(l) do
    l |> Enum.all?(fn i -> i < 0 end)
  end

  def limited(l, limit) do
    l |> Enum.all?(fn l -> abs(l) <= limit end)
  end

  def remove_one(l) do
    Enum.map(0..(length(l) - 1), fn i -> List.delete_at(l, i) end)
  end

  def check_fixable(l) do
    all_possible = remove_one(l)
    get_valid(all_possible) |> Enum.any?(&(&1 == true))
  end

  def get_valid(data) do
    diff = data |> Enum.map(&diff/1)
    positive = diff |> Enum.map(&all_positive/1)
    negative = diff |> Enum.map(&all_negative/1)
    limit = diff |> Enum.map(&limited(&1, 3))
    Enum.zip([positive, negative, limit]) |> Enum.map(fn {p, n, l} -> (p or n) and l end)
  end

  def part1(input) do
    valid = get_valid(parse(input))
    valid |> Enum.count(&(&1 == true)) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    data = parse(input)
    valid = get_valid(data)
    already_valid = valid |> Enum.count(&(&1 == true))

    to_check =
      Enum.zip(data, valid)
      |> Enum.filter(fn {_, d2} -> d2 == false end)
      |> Enum.map(fn {d, _} -> d end)

    fixable = to_check |> Enum.map(&check_fixable/1) |> Enum.count(&(&1 == true))
    (already_valid + fixable) |> IO.inspect(label: "Part 2")
  end
end
