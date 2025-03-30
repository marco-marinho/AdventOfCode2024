defmodule AOC2024.Day10 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  def check_smooth(matrix, {i, j}) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.filter(fn {dx, dy} ->
      Matrix.get(matrix, i + dx, j + dy) == Matrix.get(matrix, i, j) + 1
    end)
    |> Enum.map(fn {dx, dy} ->
      {i + dx, j + dy}
    end)
  end

  def count_trails(board, {i, j}, visited, part1) do
    cond do
      part1 and MapSet.member?(visited, {i, j}) ->
        {0, visited}

      Matrix.get(board, i, j) == 9 ->
        {1, MapSet.put(visited, {i, j})}

      true ->
        new_visited = MapSet.put(visited, {i, j})
        new_heads = check_smooth(board, {i, j})

        Enum.reduce(new_heads, {0, new_visited}, fn {a, b}, {acc_count, acc_visited} ->
          {count, nvisited} = count_trails(board, {a, b}, acc_visited, part1)
          {count + acc_count, nvisited}
        end)
    end
  end

  def solve(input, part1) do
    values =
      Helpers.input_to_char_matrix(input)
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

    board = Matrix.new(values, -1)

    heads =
      for i <- 0..(board.rows - 1),
          j <- 0..(board.cols - 1),
          Matrix.get(board, i, j) == 0,
          do: {i, j}

    Enum.reduce(heads, 0, fn {i, j}, acc ->
      {v, _} = count_trails(board, {i, j}, MapSet.new(), part1)
      acc + v
    end)
    |> IO.inspect(label: "Part #{if part1, do: 1, else: 2}")
  end

  def part1(input) do
    solve(input, true)
  end

  def part2(input) do
    solve(input, false)
  end
end
