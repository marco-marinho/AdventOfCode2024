defmodule AOC2024.Day14Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day14
  alias AOC2024.Input

  test "Day 14 part1 example" do
    capture_io(fn ->
      assert Day14.part1(Input.read_example(14, 1)) == 228_690_000
    end)
  end

  test "Day 14 part2 example" do
    capture_io(fn ->
      assert Day14.part2(Input.read_example(14, 1)) == 7093
    end)
  end
end
