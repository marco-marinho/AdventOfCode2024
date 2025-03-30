defmodule AOC2024.Day12 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  def get_dimensions_aux(target, garden, {row, col}, visited, {area, perimeter}) do
    if MapSet.member?(visited, {row, col}) do
      {area, perimeter, visited}
    else
      new_area = area + 1

      [{row, col}, {row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
      |> Enum.reduce(
        {new_area, perimeter, MapSet.put(visited, {row, col})},
        fn {r, c}, {area_acc, perimeter_acc, visited_acc} ->
          cond do
            Matrix.get(garden, r, c) == target ->
              get_dimensions_aux(target, garden, {r, c}, visited_acc, {area_acc, perimeter_acc})

            true ->
              {area_acc, [{{r, c}, {row, col}} | perimeter_acc], visited_acc}
          end
        end
      )
    end
  end

  def get_dimensions(garden, {row, col}) do
    get_dimensions_aux(Matrix.get(garden, row, col), garden, {row, col}, MapSet.new(), {0, []})
  end

  def count_breaks(coordinates) do
    coordinates = Enum.sort(coordinates)
    first = hd(coordinates)

    {chunks, _} =
      Enum.reduce(coordinates, {1, first - 1}, fn curr, {acc, prev} ->
        case curr - prev do
          1 -> {acc, curr}
          _ -> {acc + 1, curr}
        end
      end)

    chunks
  end

  def count_sides(fences, idx) do
    other_idx =
      case idx do
        0 -> 1
        1 -> 0
      end

    fences =
      Enum.group_by(fences, fn {a, _} -> elem(a, idx) end)
      |> Enum.map(fn {_, val} ->
        Enum.map(val, fn {a, b} -> {(elem(a, idx) - elem(b, idx)) / 2, elem(a, other_idx)} end)
        |> Enum.filter(fn {x, _} -> x != 0.0 end)
        |> Enum.group_by(fn {x, _} -> x end)
        |> Enum.map(fn {_, val} ->
          Enum.map(val, fn {_, y} -> y end)
        end)
      end)

    Enum.map(fences, fn fence ->
      Enum.map(fence, &count_breaks/1) |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def solve(input, func, label) do
    garden = Matrix.new(Helpers.input_to_char_matrix(input), nil)

    {values, _} =
      Enum.reduce(0..(garden.rows - 1), {0, MapSet.new()}, fn row, acc ->
        Enum.reduce(0..(garden.cols - 1), acc, fn col, {value_acc, visited_acc} ->
          cond do
            MapSet.member?(visited_acc, {row, col}) ->
              {value_acc, visited_acc}

            true ->
              {new_area, new_perimeter, new_visited} = get_dimensions(garden, {row, col})

              {value_acc + func.(new_perimeter) * new_area,
               MapSet.union(visited_acc, new_visited)}
          end
        end)
      end)

    values |> IO.inspect(label: label)
  end

  def part1(input) do
    solve(input, &length/1, "Part 1")
  end

  def part2(input) do
    func = &(count_sides(&1, 0) + count_sides(&1, 1))
    solve(input, func, "Part 2")
  end
end
