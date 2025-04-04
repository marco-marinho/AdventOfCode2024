defmodule AOC2024.Day01Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day01
  alias AOC2024.Input

  test "Day 01 part1 example" do
    capture_io(fn ->
      assert Day01.part1(Input.read_example(1, 1)) == 11
    end)
  end

  test "Day 01 part2 example" do
    capture_io(fn ->
      assert Day01.part2(Input.read_example(1, 1)) == 31
    end)
  end
end
