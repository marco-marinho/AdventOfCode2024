defmodule AOC2024.Day15 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  def is_ocupied?(board, {x, y}) do
    case Matrix.get(board, x, y) do
      "." -> false
      _ -> true
    end
  end

  def move_gliph(board, {x, y}, {n_x, n_y}) do
    gliph = Matrix.get(board, x, y)
    board = Matrix.set(board, x, y, ".")
    Matrix.set(board, n_x, n_y, gliph)
  end

  def move(board, {x, y}, dir) do
    if Matrix.get(board, x, y) == "#" do
      {board, false, {x, y}}
    else
      next =
        case dir do
          :up -> {x - 1, y}
          :down -> {x + 1, y}
          :left -> {x, y - 1}
          :right -> {x, y + 1}
        end

      cond do
        is_ocupied?(board, next) ->
          case move(board, next, dir) do
            {board, true, _} ->
              board = move_gliph(board, {x, y}, next)
              {board, true, next}

            {board, false, _} ->
              {board, false, {x, y}}
          end

        true ->
          board = move_gliph(board, {x, y}, next)
          {board, true, next}
      end
    end
  end

  def parse_command(command) do
    case command do
      "^" -> :up
      "v" -> :down
      "<" -> :left
      ">" -> :right
      _ -> nil
    end
  end

  def part1(input) do
    [puzzle, _, gliph_lines] =
      Enum.chunk_by(input, fn line ->
        line == ""
      end)

    command_gliphs = Enum.join(gliph_lines, "")

    board = Matrix.new(Helpers.input_to_char_matrix(puzzle), "#")
    {start_pos, _} = board.data |> Map.to_list() |> Enum.find(fn {_, v} -> v == "@" end)
    commands = Enum.map(String.graphemes(command_gliphs), &parse_command/1)

    {board, _} =
      Enum.reduce(commands, {board, start_pos}, fn command, {curr_board, curr_pos} ->
        {new_board, _, new_pos} = move(curr_board, curr_pos, command)
        {new_board, new_pos}
      end)

    boxes = board.data |> Map.to_list() |> Enum.filter(fn {_, v} -> v == "O" end)

    score =
      Enum.reduce(boxes, 0, fn {{x, y}, _}, acc ->
        acc + 100 * x + y
      end)

    score |> IO.inspect(label: "Part 1")
  end
end
