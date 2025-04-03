defmodule AOC2024.Day15 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  @directions %{up: {-1, 0}, down: {1, 0}, left: {0, -1}, right: {0, 1}}
  @commands %{"^" => :up, "v" => :down, "<" => :left, ">" => :right}

  def is_ocupied?(board, {x, y}) do
    case Matrix.get(board, x, y) do
      "." -> false
      _ -> true
    end
  end

  def get_next({x, y}, dir) when dir in [:up, :down, :left, :right] do
    {dx, dy} = @directions[dir]
    {x + dx, y + dy}
  end

  def parse_command(command), do: Map.get(@commands, command, nil)

  def gliph_offset(gliph) do
    case gliph do
      "[" -> 1
      "]" -> -1
      _ -> 0
    end
  end

  def move(board, {x, y}, dir, visited) do
    next = get_next({x, y}, dir)
    curr_gliph = Matrix.get(board, x, y)

    cond do
      Map.has_key?(visited, {x, y}) ->
        {board, curr_gliph, visited}

      curr_gliph == "#" ->
        {board, false, Map.put(visited, {x, y}, false)}

      is_ocupied?(board, next) ->
        case {curr_gliph, dir} do
          {gliph, dir} when dir in [:up, :down] and gliph in ["[", "]"] ->
            {board, could_move_self, visited} = move(board, next, dir, visited)

            if could_move_self do
              move(board, {x, y + gliph_offset(gliph)}, dir, Map.put(visited, {x, y}, true))
            else
              {board, could_move_self, Map.put(visited, {x, y}, false)}
            end

          {_, _} ->
            {board, could_move_other, visited} = move(board, next, dir, visited)
            {board, could_move_other, Map.put(visited, {x, y}, could_move_other)}
        end

      true ->
        case {curr_gliph, dir} do
          {gliph, dir} when dir in [:up, :down] and gliph in ["[", "]"] ->
            move(board, {x, y + gliph_offset(gliph)}, dir, Map.put(visited, {x, y}, true))

          {_, _} ->
            {board, true, Map.put(visited, {x, y}, true)}
        end
    end
  end

  def solve(board, commands, box_gliph) do
    {start_pos, _} = board.data |> Map.to_list() |> Enum.find(fn {_, v} -> v == "@" end)

    {board, _} =
      Enum.reduce(commands, {board, start_pos}, fn command, {curr_board, curr_pos} ->
        {new_board, moved, visited} = move(curr_board, curr_pos, command, Map.new())

        if moved do
          {update_board(new_board, visited, command), get_next(curr_pos, command)}
        else
          {new_board, curr_pos}
        end
      end)

    boxes = board.data |> Map.to_list() |> Enum.filter(fn {_, v} -> v == box_gliph end)

    score =
      Enum.reduce(boxes, 0, fn {{x, y}, _}, acc ->
        acc + 100 * x + y
      end)

    score
  end

  def update_board(board, visited, command) do
    to_remove = Map.keys(visited)

    to_update =
      Map.to_list(visited)
      |> Enum.map(fn {{x, y}, _} -> {get_next({x, y}, command), Matrix.get(board, x, y)} end)

    board =
      Enum.reduce(to_remove, board, fn {x, y}, acc_board ->
        Matrix.set(acc_board, x, y, ".")
      end)

    Enum.reduce(to_update, board, fn {{x, y}, v}, acc_board ->
      Matrix.set(acc_board, x, y, v)
    end)
  end

  def parse(input, part2) do
    [puzzle, _, gliph_lines] =
      Enum.chunk_by(input, fn line ->
        line == ""
      end)

    puzzle =
      if part2 do
        Enum.map(puzzle, fn line ->
          String.replace(line, "#", "##")
          |> String.replace(".", "..")
          |> String.replace("O", "[]")
          |> String.replace("@", "@.")
        end)
      else
        puzzle
      end

    board = Matrix.new(Helpers.input_to_char_matrix(puzzle), "#")
    command_gliphs = Enum.join(gliph_lines, "")
    commands = Enum.map(String.graphemes(command_gliphs), &parse_command/1)
    {board, commands}
  end

  def part1(input) do
    {board, commands} = parse(input, false)
    solve(board, commands, "O") |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    {board, commands} = parse(input, true)
    solve(board, commands, "[") |> IO.inspect(label: "Part 2")
  end
end
