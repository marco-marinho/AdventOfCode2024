defmodule AOC2024.Day04 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  def check_xmas(matrix, row, col) do
      case Matrix.get(matrix, row, col) do
        "X" -> count_xmas(matrix, row, col)
        _ -> 0
      end
  end

  def check_mas(matrix, row, col) do
      case Matrix.get(matrix, row, col) do
        "A" -> count_mas(matrix, row, col)
        _ -> 0
      end
  end

  def check(matrix, row, col, [x, y]) do
    Enum.reduce(0..3, [], fn v, acc ->
      [Matrix.get(matrix, row + x * v, col + y * v) | acc]
    end)
    |> Enum.reverse()
  end

  def count_xmas(matrix, row, col) do
    steps = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [-1, 1], [1, -1]]
    words = steps |> Enum.map(fn step -> check(matrix, row, col, step) end)
    Enum.filter(words, fn entry -> entry == ["X", "M", "A", "S"] end) |> length()
  end

  def count_mas(matrix, row, col) do
    is_mas? = fn diag ->
      Enum.sort(diag) == ["M", "S"]
    end
   diag1 = [Matrix.get(matrix, row - 1, col + 1), Matrix.get(matrix, row + 1, col - 1)]
   diag2 = [Matrix.get(matrix, row - 1, col - 1), Matrix.get(matrix, row + 1, col + 1)]
   if is_mas?.(diag1) and is_mas?.(diag2), do: 1, else: 0
  end

  def part1(input) do
      board = Matrix.new(Helpers.input_to_char_matrix(input))
      Enum.reduce(0..(board.rows - 1), 0, fn i, acc ->
        Enum.reduce(0..(board.cols - 1), acc, fn j, acc2 ->
          acc2 + check_xmas(board, i, j)
        end)
      end) |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
      board = Matrix.new(Helpers.input_to_char_matrix(input))
      Enum.reduce(0..(board.rows - 1), 0, fn i, acc ->
        Enum.reduce(0..(board.cols - 1), acc, fn j, acc2 ->
          acc2 + check_mas(board, i, j)
        end)
      end) |> IO.inspect(label: "Part 2")
  end
end
