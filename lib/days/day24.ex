defmodule AOC2024.Day24 do
  import Bitwise

  def xor(a, b) when is_boolean(a) and is_boolean(b) do
    (a and not b) or (not a and b)
  end

  def bool_from_string("1"), do: true
  def bool_from_string("0"), do: false

  def parse_input(input) do
    Enum.reduce(input, Map.new(), fn line, acc ->
      [var, val] = String.split(line, ": ")
      Map.put(acc, var, bool_from_string(val))
    end)
  end

  def parse_connections(connections) do
    Enum.reduce(connections, [], fn line, acc ->
      [input, output] = String.split(line, " -> ")
      [a, op, b] = String.split(input, " ")
      [a, b] = Enum.sort([a, b])
      [{a, b, op, output} | acc]
    end)
  end

  def resolve(inputs, []) do
    inputs
  end

  def resolve(inputs, connections) do
    {inputs, connections} =
      Enum.reduce(connections, {inputs, []}, fn {a, b, op, output}, {in_acc, con_acc} ->
        if Map.has_key?(inputs, a) and Map.has_key?(inputs, b) do
          a_val = Map.get(inputs, a)
          b_val = Map.get(inputs, b)

          in_acc =
            case op do
              "AND" -> Map.put(in_acc, output, a_val and b_val)
              "OR" -> Map.put(in_acc, output, a_val or b_val)
              "XOR" -> Map.put(in_acc, output, xor(a_val, b_val))
            end

          {in_acc, con_acc}
        else
          con_acc = [{a, b, op, output} | con_acc]
          {in_acc, con_acc}
        end
      end)

    resolve(inputs, connections)
  end

  def apply_renames(connections, renames) do
    connections
    |> Enum.map(fn {a, b, op, output} ->
      {Map.get(renames, a, a), Map.get(renames, b, b), op, Map.get(renames, output, output)}
    end)
  end

  def apply_swaps(connections, renames) do
    connections
    |> Enum.map(fn {a, b, op, output} ->
      {a, b, op, Map.get(renames, output, output)}
    end)
  end

  def alias_names(connections) do
    renames =
      connections
      |> Enum.reduce(Map.new(), fn {a, b, op, output}, acc ->
        case {a, b, op, output} do
          {"x" <> rest, "y" <> rest, "AND", to_rename} ->
            if rest == "00" do
              Map.put(acc, to_rename, "CARRY00")
            else
              Map.put(acc, to_rename, "AND" <> rest)
            end

          {"x" <> rest, "y" <> rest, "XOR", to_rename} ->
            Map.put(acc, to_rename, "XOR" <> rest)

          _ ->
            acc
        end
      end)

    renamed = apply_renames(connections, renames)

    renames_2 =
      renamed
      |> Enum.reduce(Map.new(), fn {a, b, op, output}, acc ->
        [a, b] = Enum.sort([a, b])

        case {a, b, op, output} do
          {"CARRY" <> n_0, "XOR" <> n_1, "AND", to_rename} ->
            if String.to_integer(n_1) - String.to_integer(n_0) == 1 do
              Map.put(acc, to_rename, "CARRY_INTERMEDIATE" <> n_1)
            else
              acc
            end

          {"AND" <> rest, "CARRY_INTERMEDIATE" <> rest, "OR", to_rename} ->
            Map.put(acc, to_rename, "CARRY" <> rest)

          _ ->
            acc
        end
      end)

    renames_2 = Map.filter(renames_2, fn {k, v} -> k != v end)
    renamed_2 = apply_renames(renamed, renames_2)

    if renames_2 == %{} do
      renamed_2
    else
      alias_names(renamed_2)
    end
  end

  def get_average({a, b, _, output}) do
    a_part =
      case Regex.scan(~r/\d+/, a) do
        [[a_num]] -> String.to_integer(a_num)
        _ -> 100
      end

    b_part =
      case Regex.scan(~r/\d+/, b) do
        [[b_num]] -> String.to_integer(b_num)
        _ -> 100
      end

    o_part =
      case Regex.scan(~r/\d+/, output) do
        [[o_num]] -> String.to_integer(o_num)
        _ -> 100
      end

    (a_part + b_part + o_part) / 3
  end

  def part1(input) do
    [inputs, _, rest] = Enum.chunk_by(input, &(&1 == ""))
    inputs = parse_input(inputs)
    connections = parse_connections(rest)

    resolve(inputs, connections)
    |> Map.filter(fn {k, _} -> String.contains?(k, "z") end)
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.reduce({0, 0}, fn bit, {acc, offset} ->
      if bit do
        {acc + (1 <<< offset), offset + 1}
      else
        {acc, offset + 1}
      end
    end)
    |> elem(0)
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    [_, _, rest] = Enum.chunk_by(input, &(&1 == ""))
    connections = parse_connections(rest)

    renames = %{
      "gwh" => "z09",
      "z09" => "gwh",
      "wbw" => "wgb",
      "wgb" => "wbw",
      "rcb" => "z21",
      "z21" => "rcb",
      "jct" => "z39",
      "z39" => "jct"
    }

    connections = apply_swaps(connections, renames)
    aliased_connections = alias_names(connections)

    aliased_connections =
      Enum.map(aliased_connections, fn {a, b, op, output} ->
        [a, b] = Enum.sort([a, b])
        {a, b, op, output}
      end)
      |> Enum.sort_by(fn entry -> get_average(entry) end)

    Enum.each(aliased_connections, fn {a, b, op, output} ->
      IO.puts("#{a} #{op} #{b} -> #{output}")
    end)

    ["gwh", "z09", "wbw", "wgb", "rcb", "z21", "jct", "z39"]
    |> Enum.sort()
    |> Enum.join(",")
    |> IO.inspect(label: "Part 2")
  end
end
