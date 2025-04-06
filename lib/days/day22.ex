defmodule AOC2024.Day22 do
  def evolve(secret) do
    x0 = rem(Bitwise.bxor(secret * 64, secret), 16_777_216)
    x1 = rem(Bitwise.bxor(div(x0, 32), x0), 16_777_216)
    rem(Bitwise.bxor(x1 * 2048, x1), 16_777_216)
  end

  def diff(list) do
    Enum.zip(list, tl(list)) |> Enum.map(fn {a, b} -> b - a end)
  end

  def get_points(values) do
    diff = diff(values) |> Enum.chunk_every(4, 1, :discard)
    values = values |> Enum.drop(4)

    Enum.zip(diff, values)
    |> Enum.reduce(Map.new(), fn {key, value}, acc ->
      if Map.has_key?(acc, key) do
        acc
      else
        Map.put(acc, key, value)
      end
    end)
  end

  def part1(input) do
    input = input |> Enum.map(&String.to_integer/1)

    input
    |> Enum.map(fn x ->
      Enum.reduce(1..2000, x, fn _, acc ->
        evolve(acc)
      end)
    end)
    |> Enum.sum()
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    input = input |> Enum.map(&String.to_integer/1)

    values =
      input
      |> Enum.map(fn x ->
        Enum.reduce(1..2000, {x, [rem(x, 10)]}, fn _, {secret, acc} ->
          secret = evolve(secret)
          {secret, [rem(secret, 10) | acc]}
        end)
      end)
      |> Enum.map(fn {_, acc} ->
        acc |> Enum.reverse()
      end)

    sell_points = values |> Enum.map(&get_points/1)

    all_sell_keys =
      sell_points
      |> Enum.map(fn x -> Map.keys(x) end)
      |> Enum.reduce(MapSet.new(), fn keys, acc ->
        MapSet.union(acc, MapSet.new(keys))
      end)

    possible_profits =
      all_sell_keys
      |> Enum.map(fn key ->
        sell_points
        |> Enum.map(fn x ->
          Map.get(x, key, 0)
        end)
        |> Enum.sum()
      end)
    possible_profits |> Enum.max() |> IO.inspect(label: "Part 2")
  end
end
