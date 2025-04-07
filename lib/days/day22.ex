defmodule AOC2024.Day22 do
  def evolve(secret) do
    x0 = rem(Bitwise.bxor(secret * 64, secret), 16_777_216)
    x1 = rem(Bitwise.bxor(div(x0, 32), x0), 16_777_216)
    rem(Bitwise.bxor(x1 * 2048, x1), 16_777_216)
  end

  def diff(list) do
    Enum.zip(list, tl(list)) |> Enum.map(fn {a, b} -> b - a end)
  end

  def flatten_index([x, y, z, w]) do
    (x + 9) * 18 * 18 * 18 + (y + 9) * 18 * 18 + (z + 9) * 18 + (w + 9)
  end

  def get_points(values, acc) do
    diff = diff(values) |> Enum.chunk_every(4, 1, :discard)
    values = values |> Enum.drop(4)
    visited = :array.new(19 * 19 * 19 * 19, default: false)

    Enum.zip(diff, values)
    |> Enum.reduce({acc, visited}, fn {key, value}, {acc, seen} ->
      index = flatten_index(key)

      if :array.get(index, seen) do
        {acc, seen}
      else
        n_seen = :array.set(index, true, seen)
        c_val = :array.get(index, acc)
        n_acc = :array.set(index, c_val + value, acc)
        {n_acc, n_seen}
      end
    end)
    |> elem(0)
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

    values
    |> Enum.reduce(:array.new(19 * 19 * 19 * 19, default: 0), fn values, acc ->
      get_points(values, acc)
    end)
    |> :array.to_list()
    |> Enum.max()
    |> IO.inspect(label: "Part 2")
  end
end
