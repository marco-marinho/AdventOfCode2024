defmodule AOC2024.Day10Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day10
  alias AOC2024.Input

  test "Day 10 part1 example" do
    capture_io(fn ->
    assert Day10.part1(Input.read_example(10, 1)) == 36
    end)
  end

  test "Day 10 part2 example" do
    capture_io(fn ->
    assert Day10.part2(Input.read_example(10, 1)) == 81
  end)
  end
end
