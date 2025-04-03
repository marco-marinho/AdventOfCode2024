defmodule AOC2024.Day16 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  @possible_next %{
    {0, 1} => [{1, 0, 1001}, {-1, 0, 1001}, {0, 1, 1}],
    {1, 0} => [{0, -1, 1001}, {0, 1, 1001}, {1, 0, 1}],
    {0, -1} => [{-1, 0, 1001}, {1, 0, 1001}, {0, -1, 1}],
    {-1, 0} => [{0, 1, 1001}, {0, -1, 1001}, {-1, 0, 1}]
  }

  def make_move(board, queue, {x, y}, {dx, dy}, path, cost) do
    case Matrix.get(board, x + dx, y + dy) do
      "#" ->
        queue

      _ ->
        next = {x + dx, y + dy}
        Heap.push(queue, {cost, {next, {dx, dy}, [next | path]}})
    end
  end

  def djikstra(board, queue, visited, paths) do
    if Heap.empty?(queue) do
      paths
    else
      {cost, {pos, dir, path}} = Heap.root(queue)
      {x, y} = pos
      queue = Heap.pop(queue)

      cond do
        Map.has_key?(visited, {pos, dir}) and cost > Map.get(visited, {pos, dir}) ->
          djikstra(board, queue, visited, paths)

        Matrix.get(board, x, y) == "E" ->
          case paths do
            paths when paths == [] or cost <= hd(paths) |> elem(1) ->
              djikstra(board, queue, visited, [{path, cost} | paths])

            _ ->
              paths
          end

        true ->
          visited = Map.put(visited, {pos, dir}, cost)

          queue =
            Enum.reduce(@possible_next[dir], queue, fn {dx, dy, extra_cost}, acc ->
              make_move(board, acc, {x, y}, {dx, dy}, path, cost + extra_cost)
            end)

          djikstra(board, queue, visited, paths)
      end
    end
  end

  def solve(input) do
    board = Matrix.new(Helpers.input_to_char_matrix(input), "#")
    start_pos = {board.rows - 2, 1}
    queue = Heap.push(Heap.new(), {0, {start_pos, {0, 1}, [start_pos]}})
    djikstra(board, queue, Map.new(), [])
  end

  def part1(input) do
    solve(input) |> hd() |> elem(1) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    solve(input)
    |> Enum.map(fn {l, _} -> l end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect(label: "Part 2")
  end
end
