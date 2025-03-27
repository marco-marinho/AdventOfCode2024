defmodule AOC2024.Day04 do
  alias AOC2024.Helpers
  alias AOC2024.Matrix

  def check(matrix, row, col, char, function) do
    value = Matrix.get(matrix, row, col)

    case value do
      ^char -> function.(matrix, row, col)
      _ -> 0
    end
  end

  def get_word(matrix, row, col, [x, y]) do
    Enum.reduce(1..3, [], fn v, acc ->
      [Matrix.get(matrix, row + x * v, col + y * v) | acc]
    end)
    |> Enum.reverse()
  end

  def count_xmas(matrix, row, col) do
    steps = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [-1, 1], [1, -1]]
    words = steps |> Enum.map(fn step -> get_word(matrix, row, col, step) end)

    Enum.reduce(words, 0, fn entry, acc ->
      if entry == ["M", "A", "S"], do: acc + 1, else: acc
    end)
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
        acc2 + check(board, i, j, "X", &count_xmas/3)
      end)
    end)
    |> IO.inspect(label: "Part 1")
  end

  def part2(input) do
    board = Matrix.new(Helpers.input_to_char_matrix(input))

    Enum.reduce(0..(board.rows - 1), 0, fn i, acc ->
      Enum.reduce(0..(board.cols - 1), acc, fn j, acc2 ->
        acc2 + check(board, i, j, "A", &count_mas/3)
      end)
    end)
    |> IO.inspect(label: "Part 2")
  end
end
