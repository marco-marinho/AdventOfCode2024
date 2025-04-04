defmodule AOC2024.Day15Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day15
  alias AOC2024.Input

  test "Day 15 part1 example" do
    capture_io(fn ->
    assert Day15.part1(Input.read_example(15, 1)) == 10092
    end)
  end

  test "Day 15 part2 example" do
    capture_io(fn ->
    assert Day15.part2(Input.read_example(15, 1)) == 9021
  end)
  end
end
