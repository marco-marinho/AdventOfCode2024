defmodule AOC2024.Day07Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day07
  alias AOC2024.Input

  test "Day 07 part1 example" do
    capture_io(fn ->
      assert Day07.part1(Input.read_example(7, 1)) == 3749
    end)
  end

  test "Day 07 part2 example" do
    capture_io(fn ->
      assert Day07.part2(Input.read_example(7, 1)) == 11387
    end)
  end
end
