defmodule AOC2024.Day11 do
  def number_of_digits(n) when n == 0, do: 1

  def number_of_digits(n) do
    :math.log10(abs(n)) |> floor() |> Kernel.+(1)
  end

  def pow(_, 0), do: 1
  def pow(base, exp) when exp > 0, do: base * pow(base, exp - 1)

  def blink_fast(stones) do
    Enum.reduce(stones, Map.new(), fn {stone, count}, acc ->
      digits = number_of_digits(stone)

      case stone do
        0 ->
          Map.update(acc, 1, count, &(&1 + count))

        x when rem(digits, 2) == 0 ->
          half_digits = div(digits, 2)
          pow_10 = pow(10, half_digits)

          Map.update(acc, rem(x, pow_10), count, &(&1 + count))
          |> Map.update(div(x, pow_10), count, &(&1 + count))

        x ->
          Map.update(acc, x * 2024, count, &(&1 + count))
      end
    end)
  end

  def solve(input, steps) do
    stones =
      input
      |> hd
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(%{}, fn stone, acc ->
        Map.put(acc, stone, 1)
      end)

    final_stones =
      Enum.reduce(1..steps, stones, fn _, acc ->
        blink_fast(acc)
      end)

    Enum.reduce(final_stones, 0, fn {_, v}, acc ->
      acc + v
    end)
  end

  def part1(input) do
    solve(input, 25) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    solve(input, 75) |> IO.inspect(label: "Part 2")
  end
end
