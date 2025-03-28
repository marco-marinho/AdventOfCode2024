defmodule AOC2024.Day06 do
  alias AOC2024.Helpers

  @steps [
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
  ]

  @turn_memo {1, 2, 3, 0}
  def turn(index) do
    elem(@turn_memo, index)
  end

  def walk({x, y}, obstacles, visited, step_index, {nrows, ncols}) do
    cond do
      MapSet.member?(visited, {x, y, step_index}) ->
        {visited, true}

      true ->
        new_visited = MapSet.put(visited, {x, y, step_index})
        {dx, dy} = Enum.at(@steps, step_index)
        {new_x, new_y} = {x + dx, y + dy}

        cond do
          new_x >= nrows or new_y >= ncols or new_x < 0 or new_y < 0 ->
            {new_visited, false}

          MapSet.member?(obstacles, {new_x, new_y}) ->
            walk({x, y}, obstacles, visited, turn(step_index), {nrows, ncols})

          true ->
            walk({new_x, new_y}, obstacles, new_visited, step_index, {nrows, ncols})
        end
    end
  end

  def get_original_route(input) do
    board = Helpers.input_to_char_matrix(input)
    {rows, cols} = {length(board), length(hd(board))}

    {obstacles, {x, y}} =
      Enum.with_index(board)
      |> Enum.reduce({[], {-1, -1}}, fn {row, i}, acc ->
        Enum.with_index(row)
        |> Enum.reduce(acc, fn {v, j}, {barriers, {a, b}} ->
          case v do
            "." -> {barriers, {a, b}}
            "#" -> {[{i, j} | barriers], {a, b}}
            "^" -> {barriers, {i, j}}
          end
        end)
      end)

    {positions, _} = walk({x, y}, MapSet.new(obstacles), MapSet.new(), 0, {rows, cols})
    {{x, y}, board, obstacles, {rows, cols}, positions}
  end

  def get_visited_positions(positions) do
    positions |> Enum.reduce(MapSet.new(), fn {x, y, _}, acc -> acc |> MapSet.put({x, y}) end)
  end

  def part1(input) do
    {_, _, _, _, positions} = get_original_route(input)

    positions
    |> Enum.reduce(MapSet.new(), fn {x, y, _}, acc -> acc |> MapSet.put({x, y}) end)
    |> MapSet.size()
    |> IO.inspect()
  end

  def part2(input) do
    {start_pos, _, obstacles, size, positions} = get_original_route(input)
    visited_position = get_visited_positions(positions) |> MapSet.delete(start_pos)
    obstaces = MapSet.new(obstacles)

    visited_position
    |> Enum.reduce(0, fn {x, y}, acc ->
      case walk(start_pos, MapSet.put(obstaces, {x, y}), MapSet.new(), 0, size) do
        {_, true} -> acc + 1
        {_, false} -> acc
      end
    end)
    |> IO.inspect()
  end
end
