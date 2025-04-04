defmodule AOC2024.Day16Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day16
  alias AOC2024.Input

  test "Day 16 part1 example" do
    capture_io(fn ->
    assert Day16.part1(Input.read_example(16, 1)) == 11048
    end)
  end

  test "Day 16 part2 example" do
    capture_io(fn ->
    assert Day16.part2(Input.read_example(16, 1)) == 64
  end)
  end
end
