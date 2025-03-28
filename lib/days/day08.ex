defmodule AOC2024.Day08 do
  alias AOC2024.Helpers

  def update_part1({x1, y1}, {x2, y2}, {dx, dy}, {_, _}, acc) do
    [{x1 + dx, y1 + dy}, {x2 - dx, y2 - dy} | acc]
  end

  def update_part2({x1, y1}, {x2, y2}, {dx, dy}, {max_x, max_y}, acc) do
    acc = get_all({x1, y1}, {dx, dy}, {max_x, max_y}, acc)
    get_all({x2, y2}, {-dx, -dy}, {max_x, max_y}, acc)
  end

  def antinodes(antennas, {max_x, max_y}, update_fun) do
    combinations = for x <- antennas, y <- antennas, x < y, do: {x, y}

    combinations
    |> Enum.reduce([], fn {{x1, y1}, {x2, y2}}, acc ->
      {dx, dy} = {x1 - x2, y1 - y2}
      update_fun.({x1, y1}, {x2, y2}, {dx, dy}, {max_x, max_y}, acc)
    end)
  end

  def get_all({x, y}, {dx, dy}, {x_lim, y_lim}, acc) do
    new_x = x + dx
    new_y = y + dy

    cond do
      new_x < 0 or new_y < 0 or new_x >= x_lim or new_y >= y_lim ->
        acc

      true ->
        get_all({new_x, new_y}, {dx, dy}, {x_lim, y_lim}, [{new_x, new_y} | acc])
    end
  end

  def get_antennas(input) do
    data = Helpers.input_to_char_matrix(input)
    {rows, cols} = {length(data), length(hd(data))}

    antennas =
      Enum.with_index(data)
      |> Enum.flat_map(fn {row, i} ->
        Enum.with_index(row)
        |> Enum.filter(fn {v, _} -> v != "." end)
        |> Enum.map(fn {v, j} -> {v, {i, j}} end)
      end)
      |> Enum.group_by(fn {v, _} -> v end, fn {_, pos} -> pos end)

    {antennas, {rows, cols}}
  end

  def part1(input) do
    {antennas, {rows, cols}} = get_antennas(input)

    antinodes =
      antennas
      |> Enum.map(fn {_, positions} -> antinodes(positions, {rows, cols}, &update_part1/5) end)

    valid_antinodes =
      antinodes
      |> Enum.map(fn list ->
        list
        |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 and x < rows and y < cols end)
        |> MapSet.new()
      end)

    ans =
      valid_antinodes
      |> Enum.reduce(MapSet.new(), fn set, acc ->
        MapSet.union(acc, set)
      end)

    ans |> MapSet.size() |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    {antennas, {rows, cols}} = get_antennas(input)

    antinodes =
      antennas
      |> Enum.map(fn {_, positions} -> antinodes(positions, {rows, cols}, &update_part2/5) end)

    valid_antinodes =
      Enum.reduce(antennas, MapSet.new(), fn {_, positions}, acc ->
        MapSet.union(acc, MapSet.new(positions))
      end)
      |> then(fn set ->
        Enum.reduce(antinodes, set, fn list, acc ->
          MapSet.union(acc, MapSet.new(list))
        end)
      end)

    MapSet.size(valid_antinodes) |> IO.inspect(label: "Part 2")
  end
end
