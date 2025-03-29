defmodule AOC2024.Day09 do
  alias AOC2024.Helpers

  def parse(values, acc, tag, id) do
    if length(values) == 0 do
      Enum.filter(acc, fn {_, v, _} -> v > 0 end) |> Enum.reverse() |> List.to_tuple()
    else
      {new_tag, next_id} =
        case {tag, id} do
          {:file, x} -> {:space, x + 1}
          {:space, x} -> {:file, x}
        end

      [v | rest] = values
      parse(rest, [{tag, v, id} | acc], new_tag, next_id)
    end
  end

  def parse2(values, acc, tag, id, offset) do
    if length(values) == 0 do
      files = Enum.filter(acc, fn {tag, _, _, _} -> tag == :file end)

      spaces =
        Enum.filter(acc, fn {tag, v, _, _} -> tag == :space and v > 0 end) |> Enum.reverse()

      {files, spaces}
    else
      {new_tag, next_id} =
        case {tag, id} do
          {:file, x} -> {:space, x + 1}
          {:space, x} -> {:file, x}
        end

      [v | rest] = values
      parse2(rest, [{tag, v, id, offset} | acc], new_tag, next_id, offset + v)
    end
  end

  def allocate(space, block) do
    {space_tag, space_value, space_id} = space
    {block_tag, block_value, block_id} = block

    case space_tag do
      :file ->
        raise "Invalid allocation"

      :space ->
        space_left = space_value - block_value

        case space_left do
          x when x < 0 ->
            {{{block_tag, space_value, block_id}, nil},
             {block_tag, block_value - space_value, block_id}}

          x when x == 0 ->
            {{{block_tag, space_value, block_id}, nil}, nil}

          x when x > 0 ->
            {{{block_tag, block_value, block_id}, {:space, space_value - block_value, space_id}},
             nil}
        end
    end
  end

  def allocate2(spaces, block, index, size) when index >= size do
    {block, spaces}
  end

  def allocate2(spaces, block, index, size) do
    current = Map.get(spaces, index)
    {_, space_value, space_id, space_offset} = current
    {block_tag, block_value, block_id, block_offset} = block

    cond do
      space_offset > block_offset ->
        {block, spaces}

      space_value < block_value ->
        allocate2(spaces, block, index + 1, size)

      space_value >= block_value ->
        {{block_tag, block_value, block_id, space_offset},
         Map.put(
           spaces,
           index,
           {:space, space_value - block_value, space_id, space_offset + block_value}
         )}
    end
  end

  def compress2(blocks, spaces) do
    spaces_size = map_size(spaces)

    Enum.reduce(blocks, {spaces, []}, fn block, {spaces, acc} ->
      {allocated, new_spaces} = allocate2(spaces, block, 0, spaces_size)
      {new_spaces, [allocated | acc]}
    end)
    |> elem(1)
  end

  def compress(blocks, {head_block, head_p}, {tail_block, tail_p}, acc) do
    if head_p >= tail_p do
      {tail_tag, _, _} = tail_block

      case tail_tag do
        :file -> [tail_block | acc]
        :space -> acc
      end
    else
      {head_tag, _, _} = head_block
      {tail_tag, _, _} = tail_block

      case {head_tag, tail_tag} do
        {:file, _} ->
          next_head = elem(blocks, head_p + 1)
          compress(blocks, {next_head, head_p + 1}, {tail_block, tail_p}, [head_block | acc])

        {:space, :space} ->
          next_tail = elem(blocks, tail_p - 1)
          compress(blocks, {head_block, head_p}, {next_tail, tail_p - 1}, acc)

        {:space, :file} ->
          {{allocatable, space_left}, file_left} = allocate(head_block, tail_block)

          case {allocatable, space_left, file_left} do
            {h, nil, nil} ->
              next_head = elem(blocks, head_p + 1)
              next_tail = elem(blocks, tail_p - 1)
              compress(blocks, {next_head, head_p + 1}, {next_tail, tail_p - 1}, [h | acc])

            {h, s, nil} ->
              next_head = s
              next_tail = elem(blocks, tail_p - 1)
              compress(blocks, {next_head, head_p}, {next_tail, tail_p - 1}, [h | acc])

            {h, nil, f} ->
              next_head = elem(blocks, head_p + 1)
              next_tail = f
              compress(blocks, {next_head, head_p + 1}, {next_tail, tail_p}, [h | acc])
          end
      end
    end
  end

  def part1(input) do
    values = Helpers.input_to_char_matrix(input) |> hd |> Enum.map(&String.to_integer/1)
    blocks = parse(values, [], :file, 0)

    compressed =
      compress(
        blocks,
        {elem(blocks, 0), 0},
        {elem(blocks, tuple_size(blocks) - 1), tuple_size(blocks) - 1},
        []
      )
      |> Enum.reverse()

    {ans, _} =
      compressed
      |> Enum.reduce({0, 0}, fn {_, value, id}, {acc, offset} ->
        nacc = acc + (Enum.map(offset..(offset + value - 1), fn x -> x * id end) |> Enum.sum())
        noffset = offset + value
        {nacc, noffset}
      end)

    ans |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    values = Helpers.input_to_char_matrix(input) |> hd |> Enum.map(&String.to_integer/1)
    {files, spaces} = parse2(values, [], :file, 0, 0)
    spaces = Enum.with_index(spaces) |> Enum.reduce(%{}, fn {x, i}, acc -> Map.put(acc, i, x) end)
    allocations = compress2(files, spaces)

    allocations
    |> Enum.reduce(0, fn {_, value, id, offset}, acc ->
      nacc = acc + id * (value * (2 * offset + value - 1) / 2)
      nacc
    end)
    |> trunc
    |> IO.inspect(label: "Part 2")
  end
end
