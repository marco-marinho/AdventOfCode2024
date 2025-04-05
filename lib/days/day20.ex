defmodule AOC2024.Day20 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  @possible_next [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

  def bfs(board, queue, visited) do
    if queue == [] do
      []
    else
      [{pos, path} | tail] = queue
      {x, y} = pos
      new_path = [pos | path]

      cond do
        MapSet.member?(visited, pos) ->
          bfs(board, queue, visited)

        Matrix.get(board, x, y) == "E" ->
          Enum.reverse(new_path)

        true ->
          visited = MapSet.put(visited, pos)

          nqueue =
            Enum.reduce(@possible_next, tail, fn {dx, dy}, acc ->
              nx = x + dx
              ny = y + dy

              if Matrix.get(board, nx, ny) != "#" and not MapSet.member?(visited, {nx, ny}) do
                [{{x + dx, y + dy}, new_path} | acc]
              else
                acc
              end
            end)

          bfs(board, nqueue, visited)
      end
    end
  end

  def get_skips([], acc, _) do
    acc
  end

  def get_skips(path, acc, max_len) do
    [{curr_x, curr_y} | rest] = path

    nacc =
      Enum.with_index(rest)
      |> Enum.drop(max_len)
      |> Enum.reduce(acc, fn {{other_x, other_y}, idx}, iacc ->
        dist = abs(curr_x - other_x) + abs(curr_y - other_y)

        if dist <= max_len do
          [idx - dist + 1 | iacc]
        else
          iacc
        end
      end)

    get_skips(rest, nacc, max_len)
  end

  def solve(input, max_len) do
    board = Matrix.new(Helpers.input_to_char_matrix(input), "#")
    start_pos = board.data |> Map.to_list() |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)
    path = bfs(board, [{start_pos, []}], MapSet.new())

    get_skips(path, [], max_len)
    |> Enum.frequencies()
    |> Map.filter(fn {k, _} -> k >= 100 end)
    |> Map.values()
    |> Enum.sum()
  end

  def part1(input) do
    solve(input, 2) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    solve(input, 20)
    |> IO.inspect(label: "Part 2")
  end
end
