defmodule AOC2024.Matrix do
  defstruct rows: 0, cols: 0, data: %{}, default: ""

  def new(idata, default) do
    rows = length(idata)
    cols = length(hd(idata))

    data =
      idata
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, i}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {val, j}, acc2 ->
          Map.put(acc2, {i, j}, val)
        end)
      end)

    %AOC2024.Matrix{rows: rows, cols: cols, data: data, default: default}
  end

  def new(idata) do
    new(idata, "")
  end

  def get(%AOC2024.Matrix{data: data, default: default}, row, col) do
    Map.get(data, {row, col}, default)
  end

  def set(%AOC2024.Matrix{} = matrix, row, col, val) do
    %AOC2024.Matrix{matrix | data: Map.put(matrix.data, {row, col}, val)}
  end

  def to_grid(%AOC2024.Matrix{rows: rows, cols: cols, data: data, default: default}) do
    for i <- 0..(rows - 1) do
      for j <- 0..(cols - 1) do
        Map.get(data, {i, j}, default)
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end
end

defimpl Inspect, for: AOC2024.Matrix do
  import Inspect.Algebra

  def inspect(matrix, _opts) do
    grid = AOC2024.Matrix.to_grid(matrix)
    concat(["\nMatrix (#{matrix.rows}x#{matrix.cols}):\n", grid, "\n"])
  end
end
