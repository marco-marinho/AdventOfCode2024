defmodule AOC2024.Day18 do
  def check_bounds({x, y}, {x_lim, y_lim}) do
    x >= 0 and x <= x_lim and y >= 0 and y <= y_lim
  end

  def make_move(blocks, queue, {x, y}, {x_lim, y_lim}, cost) do
    [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    |> Enum.reduce(queue, fn {dx, dy}, acc ->
      next = {x + dx, y + dy}

      if check_bounds(next, {x_lim, y_lim}) and not MapSet.member?(blocks, next) do
        Heap.push(acc, {cost + 1, next})
      else
        acc
      end
    end)
  end

  def djikstra(blocks, queue, visited, limits) do
    if Heap.empty?(queue) do
      -1
    else
      {cost, pos} = Heap.root(queue)
      queue = Heap.pop(queue)

      cond do
        MapSet.member?(visited, pos) ->
          djikstra(blocks, queue, visited, limits)

        pos == limits ->
          cost

        true ->
          visited = MapSet.put(visited, pos)
          queue = make_move(blocks, queue, pos, limits, cost)
          djikstra(blocks, queue, visited, limits)
      end
    end
  end

  def binary_search(low, high, _, _) when low >= high do
    -1
  end

  def binary_search(low, high, blocks, limits) do
    mid = div(low + high, 2)
    queue = Heap.new()
    queue = Heap.push(queue, {0, {0, 0}})
    cost = djikstra(MapSet.new(Enum.take(blocks, mid)), queue, MapSet.new(), limits)
    cost_other = djikstra(MapSet.new(Enum.take(blocks, mid - 1)), queue, MapSet.new(), limits)

    cond do
      cost == -1 and cost_other != -1 ->
        mid - 1

      cost == -1 ->
        binary_search(low, mid - 1, blocks, limits)

      true ->
        binary_search(mid + 1, high, blocks, limits)
    end
  end

  def part1(input) do
    blocks =
      input
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    queue = Heap.new()
    queue = Heap.push(queue, {0, {0, 0}})

    djikstra(MapSet.new(Enum.take(blocks, 1024)), queue, MapSet.new(), {70, 70})
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    blocks =
      input
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    idx = binary_search(0, 3450, blocks, {70, 70})

    Enum.at(blocks, idx)
    |> IO.inspect(label: "Part 2")
  end
end
