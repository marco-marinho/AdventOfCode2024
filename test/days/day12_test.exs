defmodule AOC2024.Day12Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day12
  alias AOC2024.Input

  test "Day 12 part1 example" do
    capture_io(fn ->
      assert Day12.part1(Input.read_example(12, 1)) == 1930
    end)
  end

  test "Day 12 part2 example" do
    capture_io(fn ->
      assert Day12.part2(Input.read_example(12, 1)) == 1206
    end)
  end
end
