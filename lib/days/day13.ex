defmodule AOC2024.Day13 do
  def parse(chunk) do
    parse_values = fn line ->
      line
      |> String.split(": ")
      |> Enum.drop(1)
      |> hd
      |> String.split(" ")
      |> Enum.map(fn x ->
        String.replace(x, ~r/[XY,=]/, "")
      end)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end

    Enum.take(chunk, 3) |> Enum.map(fn x -> parse_values.(x) end)
  end

  def solve_system([[xa, ya], [xb, yb], [tx, ty]]) do
    det = xa * yb - ya * xb
    i = yb * tx - ty * xb
    j = ty * xa - tx * ya

    if rem(i, det) == 0 and rem(j, det) == 0 do
      [div(i, det), div(j, det)]
    else
      [0, 0]
    end
  end

  def solve(input, to_add, label) do
    blocks = Enum.chunk_every(input, 4) |> Enum.map(fn x -> parse(x) end)

    blocks
    |> Enum.reduce(0, fn [a, b, [tx, ty]], acc ->
      [i, j] = solve_system([a, b, [tx + to_add, ty + to_add]])
      acc + i * 3 + j
    end)
    |> IO.inspect(label: label)
  end

  def part1(input) do
    solve(input, 0, "Part 1")
  end

  def part2(input) do
    solve(input, 10_000_000_000_000, "Part 2")
  end
end
