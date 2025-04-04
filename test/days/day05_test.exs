defmodule AOC2024.Day05Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day05
  alias AOC2024.Input

  test "Day 05 part1 example" do
    capture_io(fn ->
      assert Day05.part1(Input.read_example(5, 1)) == 143
    end)
  end

  test "Day 05 part2 example" do
    capture_io(fn ->
      assert Day05.part2(Input.read_example(5, 1)) == 123
    end)
  end
end
