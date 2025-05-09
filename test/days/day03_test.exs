defmodule AOC2024.Day03Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day03
  alias AOC2024.Input

  test "Day 03 part1 example" do
    capture_io(fn ->
      assert Day03.part1(Input.read_example(3, 1)) == 161
    end)
  end

  test "Day 03 part2 example" do
    capture_io(fn ->
      assert Day03.part2(Input.read_example(3, 2)) == 48
    end)
  end
end
