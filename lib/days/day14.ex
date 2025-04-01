defmodule AOC2024.Day14 do
  def wrap(pos, size) do
    pos = rem(pos, size)

    if pos < 0 do
      size + pos
    else
      pos
    end
  end

  def calculate_pos({x, y}, {dx, dy}, {w, h}, steps) do
    x_pos = x + dx * steps
    y_pos = y + dy * steps
    {wrap(x_pos, w), wrap(y_pos, h)}
  end

  def print_nodes(nodes, {w, h}) do
    for y <- 0..(h - 1) do
      for x <- 0..(w - 1) do
        if MapSet.member?(nodes, {x, y}) do
          IO.write("O")
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end
  end

  def check_tree(nodes) do
    Enum.group_by(nodes, fn {x, _} -> x end)
    |> Enum.map(fn {_, l} ->
      Enum.map(l, fn {_, y} -> y end)
      |> Enum.sort()
      |> Enum.reduce({0, 0, -1}, fn v, {max, current, prev} ->
        if v == prev + 1 do
          {max, current + 1, v}
        else
          {max(max, current), 1, v}
        end
      end)
    end)
    |> Enum.map(fn {max, _, _} -> max end)
    |> Enum.max()
  end

  def find_tree(positions, {w, h}, step) do
    new_pos =
      Enum.map(positions, fn {pos, vel} ->
        calculate_pos(pos, vel, {w, h}, step)
      end)

    if check_tree(new_pos) >= 10 do
      print_nodes(MapSet.new(new_pos), {w, h})
      step |> IO.inspect(label: "Part 2")
    else
      find_tree(positions, {w, h}, step + 1)
    end
  end

  def parse(input) do
    Enum.map(input, fn line ->
      [x, y] = String.split(line, " ")

      pos =
        String.replace(x, "p=", "")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()

      vel =
        String.replace(y, "v=", "")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()

      {pos, vel}
    end)
  end

  def part1(input) do
    {w, h} = {101, 103}
    positions = parse(input)

    final_position =
      Enum.map(positions, fn {pos, vel} ->
        calculate_pos(pos, vel, {w, h}, 100)
      end)

    x_lim = div(w, 2)
    y_lim = div(h, 2)

    Enum.reduce(final_position, {0, 0, 0, 0}, fn {x, y}, {q1, q2, q3, q4} ->
      cond do
        x > x_lim and y > y_lim ->
          {q1 + 1, q2, q3, q4}

        x < x_lim and y < y_lim ->
          {q1, q2 + 1, q3, q4}

        x > x_lim and y < y_lim ->
          {q1, q2, q3 + 1, q4}

        x < x_lim and y > y_lim ->
          {q1, q2, q3, q4 + 1}

        true ->
          {q1, q2, q3, q4}
      end
    end)
    |> Tuple.to_list()
    |> Enum.reduce(1, fn x, acc -> x * acc end)
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    {w, h} = {101, 103}
    positions = parse(input)
    find_tree(positions, {w, h}, 0)
  end
end
