defmodule AOC2024.Day02Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day02
  alias AOC2024.Input

  test "Day 02 part1 example" do
    capture_io(fn ->
      assert Day02.part1(Input.read_example(2, 1)) == 2
    end)
  end

  test "Day 02 part2 example" do
    capture_io(fn ->
      assert Day02.part2(Input.read_example(2, 1)) == 4
    end)
  end
end
