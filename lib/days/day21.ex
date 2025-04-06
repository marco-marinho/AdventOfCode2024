defmodule AOC2024.Day21 do
  alias AOC2024.Matrix

  @numerical Matrix.new([[7, 8, 9], [4, 5, 6], [1, 2, 3], [nil, 0, :activate]], nil)
  @directional Matrix.new([[nil, :up, :activate], [:left, :down, :right]], nil)
  @movements [
    {{0, 1}, :right},
    {{1, 0}, :down},
    {{0, -1}, :left},
    {{-1, 0}, :up}
  ]
  @numerical_vals [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, :activate]
  @numerical_product for x <- @numerical_vals, y <- @numerical_vals, x != y, do: {x, y}
  @directional_vals [:up, :down, :left, :right, :activate]
  @directional_product for x <- @directional_vals, y <- @directional_vals, x != y, do: {x, y}

  def get_positions(values, board) do
    Enum.reduce(values, Map.new(), fn x, acc ->
      pos =
        board.data
        |> Map.to_list()
        |> Enum.find(fn {_, v} -> v == x end)
        |> elem(0)

      Map.put(acc, x, pos)
    end)
  end

  defp numerical_positions do
    get_positions(@numerical_vals, @numerical)
  end

  defp directional_positions do
    get_positions(@directional_vals, @directional)
  end

  def step({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  def bfs(board, queue, target, visited, paths) do
    if :queue.is_empty(queue) do
      paths
    else
      {{_, {pos, path}}, queue_rest} = :queue.out(queue)
      element = Matrix.get(board, pos)

      case Map.get(visited, pos, nil) do
        other_cost when element == target ->
          if other_cost == nil or length(path) <= other_cost do
            bfs(board, queue_rest, target, Map.put(visited, pos, length(path)), [
              Enum.reverse([:activate | path]) | paths
            ])
          else
            paths
          end

        other_cost when other_cost != nil and length(path) > other_cost ->
          if Matrix.get(board, pos) == target do
            paths
          else
            bfs(board, queue_rest, target, visited, paths)
          end

        _ ->
          visited = Map.put(visited, pos, length(path))

          nqueue =
            Enum.reduce(@movements, queue_rest, fn {change, dir}, acc ->
              new_pos = step(pos, change)
              new_path = [dir | path]

              if Matrix.get(board, new_pos) != nil do
                :queue.in({new_pos, new_path}, acc)
              else
                acc
              end
            end)

          bfs(board, nqueue, target, visited, paths)
      end
    end
  end

  def get_possible(board, start, target) do
    bfs(
      board,
      :queue.in({start, []}, :queue.new()),
      target,
      %{},
      []
    )
  end

  def find_min(seq, remaining, lengths, movements, cache) do
    if Map.has_key?(cache, {seq, remaining}) do
      {Map.get(cache, {seq, remaining}), cache}
    else
      if remaining == 1 do
        res_val =
          Enum.chunk_every([:activate] ++ seq, 2, 1, :discard)
          |> Enum.map(&List.to_tuple/1)
          |> Enum.reduce(0, fn mov, acc ->
            Map.get(lengths, mov, 1) + acc
          end)

        {res_val, Map.put(cache, {seq, remaining}, res_val)}
      else
        {res_val, res_cache} =
          Enum.chunk_every([:activate] ++ seq, 2, 1, :discard)
          |> Enum.map(&List.to_tuple/1)
          |> Enum.reduce({0, cache}, fn mov, {acc_v, acc_cache} ->
            {lens, cache} =
              Map.get(movements, mov, [[:activate]])
              |> Enum.reduce({[], acc_cache}, fn inner_mov, {acc, inner_cache} ->
                {value, ncache} =
                  find_min(inner_mov, remaining - 1, lengths, movements, inner_cache)

                {[value | acc], ncache}
              end)

            {acc_v + Enum.min(lens), cache}
          end)

        {res_val, Map.put(res_cache, {seq, remaining}, res_val)}
      end
    end
  end

  def parse(input) do
    input
    |> Enum.map(fn line ->
      values =
        line
        |> String.graphemes()
        |> Enum.take(3)
        |> Enum.map(&String.to_integer/1)

      [:activate | values] ++ [:activate]
    end)
  end

  def solve(input, depth) do
    numerical_transitions =
      Enum.reduce(@numerical_product, Map.new(), fn {x, y}, acc ->
        x_pos = Map.get(numerical_positions(), x)
        possible = get_possible(@numerical, x_pos, y)
        Map.put(acc, {x, y}, possible)
      end)

    directional_transitions =
      Enum.reduce(@directional_product, Map.new(), fn {x, y}, acc ->
        x_pos = Map.get(directional_positions(), x)
        possible = get_possible(@directional, x_pos, y)
        Map.put(acc, {x, y}, possible)
      end)

    directional_lenghts =
      Enum.reduce(directional_transitions, Map.new(), fn {k, v}, acc ->
        Map.put(acc, k, hd(v) |> length)
      end)

    seqs = parse(input)

    seqs
    |> Enum.map(fn seq ->
      [a, b, c, d] =
        Enum.chunk_every(seq, 2, 1, :discard)
        |> Enum.map(fn [x, y] -> Map.get(numerical_transitions, {x, y}) end)

      product =
        for x <- a, y <- b, z <- c, w <- d do
          x ++ y ++ z ++ w
        end

      numeric = Enum.drop(seq, 1) |> Enum.take(3) |> Enum.join("") |> String.to_integer()

      length =
        product
        |> Enum.map(fn x ->
          {res, _} = find_min(x, depth, directional_lenghts, directional_transitions, %{})
          res
        end)
        |> Enum.min()

      numeric * length
    end)
    |> Enum.sum()
  end

  def part1(input) do
    solve(input, 2) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    solve(input, 25) |> IO.inspect(label: "Part 2")
  end
end
