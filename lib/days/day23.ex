defmodule AOC2024.Day23 do
  def update_connection(map, x, y) do
    map
    |> Map.update(x, MapSet.new([y]), fn v ->
      MapSet.put(v, y)
    end)
    |> Map.update(y, MapSet.new([x]), fn v ->
      MapSet.put(v, x)
    end)
  end

  def get_triplets([], _, acc) do
    acc |> Enum.reverse()
  end

  def get_triplets([head | tail], map, acc) do
    connections = Map.get(map, head)

    triads =
      tail
      |> Enum.reduce([], fn other, acc ->
        if MapSet.member?(connections, other) do
          triad_buff =
            Map.get(map, other)
            |> MapSet.intersection(connections)
            |> Enum.reduce([], fn third, iacc ->
              if third > other do
                [{head, other, third} | iacc]
              else
                iacc
              end
            end)

          triad_buff ++ acc
        else
          acc
        end
      end)

    get_triplets(tail, map, triads ++ acc)
  end

  def triad_has_t({a, b, c}) do
    String.starts_with?(a, "t") or
      String.starts_with?(b, "t") or
      String.starts_with?(c, "t")
  end

  def bron_kerbosch(map, r, p, x, cliques) do
    cond do
      MapSet.size(p) == 0 and MapSet.size(x) == 0 ->
        [r | cliques]

      MapSet.size(p) == 0 ->
        cliques

      true ->
        v = Enum.at(p, 0)
        neighbors = Map.get(map, v)

        new_cliques =
          bron_kerbosch(
            map,
            MapSet.put(r, v),
            MapSet.intersection(p, neighbors),
            MapSet.intersection(x, neighbors),
            cliques
          )

        p = MapSet.delete(p, v)
        x = MapSet.put(x, v)
        bron_kerbosch(map, r, p, x, new_cliques)
    end
  end

  def parse(input) do
    map =
      input
      |> Enum.reduce(Map.new(), fn line, acc ->
        [x, y] = String.split(line, "-")
        update_connection(acc, x, y)
      end)

    keys =
      map
      |> Map.keys()
      |> Enum.sort()

    {keys, map}
  end

  def part1(input) do
    {keys, map} = parse(input)
    get_triplets(keys, map, []) |> Enum.count(&triad_has_t/1) |> IO.inspect()
  end

  def part2(input) do
    {keys, map} = parse(input)

    bron_kerbosch(map, MapSet.new(), MapSet.new(keys), MapSet.new(), [])
    |> Enum.max_by(&MapSet.size/1)
    |> MapSet.to_list()
    |> Enum.join(",")
    |> IO.inspect()
  end
end
