defmodule AOC2024.Day19Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day19
  alias AOC2024.Input

  test "Day 19 part1 example" do
    capture_io(fn ->
      assert Day19.part1(Input.read_example(19, 1)) == 6
    end)
  end

  test "Day 19 part2 example" do
    capture_io(fn ->
      assert Day19.part2(Input.read_example(19, 1)) == 16
    end)
  end
end
