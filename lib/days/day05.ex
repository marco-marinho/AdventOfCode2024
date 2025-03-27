defmodule AOC2024.Day05 do
  @spec sort(list(), list(), map(), map()) :: list()
  def sort(queue, result, graph, in_degree) do
    case queue do
      [] ->
        Enum.reverse(result)

      [x | tail] ->
        result = [x | result]

        {n_queue, n_in_degree} =
          Enum.reduce(Map.get(graph, x, []), {tail, in_degree},
          fn neighbor, {queue_acc, in_degree_acc} ->
            in_degree_acc =
              Map.update(in_degree_acc, neighbor, 0, fn x -> x - 1 end)

            if in_degree_acc[neighbor] == 0 do
              {[neighbor | queue_acc], in_degree_acc}
            else
              {queue_acc, in_degree_acc}
            end
          end)

        sort(n_queue, result, graph, n_in_degree)
    end
  end

  @spec gen_graph(list()) :: tuple()
  def gen_graph(dependencies) do
    dependencies
    |> Enum.reduce({%{}, MapSet.new(), %{}}, fn [first, second], {graph, nodes, in_degree} ->
      graph = Map.update(graph, first, MapSet.new([second]), fn x -> MapSet.put(x, second) end)
      nodes = nodes |> MapSet.put(first) |> MapSet.put(second)
      in_degree = Map.update(in_degree, second, 1, fn x -> x + 1 end)
      {graph, nodes, in_degree}
    end)
  end

  @spec filter_dependencies(list(), list()) :: list()
  def filter_dependencies(dependencies, update) do
    Enum.reduce(dependencies, [], fn [x, y], acc ->
      if Enum.member?(update, x) and Enum.member?(update, y) do
        [[x, y] | acc]
      else
        acc
      end
    end)
  end

  @spec gen_queue(list(), map()) :: list()
  def gen_queue(nodes, in_degree) do
    nodes
    |> Enum.reduce([], fn node, acc ->
      case Map.get(in_degree, node, 0) == 0 do
        true -> [node | acc]
        false -> acc
      end
    end)
  end

  @spec solve(list()) :: tuple()
  def solve(input) do
    {dependencies, [_ | updates]} = input |> Enum.split_while(fn x -> x != "" end)

    updates =
      updates
      |> Enum.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)

    dependencies =
      dependencies
      |> Enum.map(fn line -> String.split(line, "|") |> Enum.map(&String.to_integer/1) end)

    Enum.reduce(updates, {0, 0}, fn update, {positive, negative} ->
      dependency = filter_dependencies(dependencies, update)
      {graph, nodes, in_degree} = gen_graph(dependency)
      queue = gen_queue(nodes, in_degree)
      order = sort(queue, [], graph, in_degree)

      case update == order do
        true -> {positive + Enum.at(update, div(length(update), 2)), negative}
        false -> {positive, negative + Enum.at(order, div(length(order), 2))}
      end
    end)
  end

  def part1(input) do
    {ans, _} = solve(input)
    ans |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    {_, ans} = solve(input)
    ans |> IO.inspect(label: "Part 2")
  end
end
