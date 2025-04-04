defmodule AOC2024.Day04Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day04
  alias AOC2024.Input

  test "Day 04 part1 example" do
    capture_io(fn ->
      assert Day04.part1(Input.read_example(4, 1)) == 18
    end)
  end

  test "Day 04 part2 example" do
    capture_io(fn ->
      assert Day04.part2(Input.read_example(4, 1)) == 9
    end)
  end
end
