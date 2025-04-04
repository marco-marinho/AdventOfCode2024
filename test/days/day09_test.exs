defmodule AOC2024.Day09Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day09
  alias AOC2024.Input

  test "Day 09 part1 example" do
    capture_io(fn ->
      assert Day09.part1(Input.read_example(9, 1)) == 1928
    end)
  end

  test "Day 09 part2 example" do
    capture_io(fn ->
      assert Day09.part2(Input.read_example(9, 1)) == 2858
    end)
  end
end
