defmodule AOC2024.Day08Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day08
  alias AOC2024.Input

  test "Day 08 part1 example" do
    capture_io(fn ->
    assert Day08.part1(Input.read_example(8, 1)) == 14
    end)
  end

  test "Day 08 part2 example" do
    capture_io(fn ->
    assert Day08.part2(Input.read_example(8, 1)) == 34
  end)
  end
end
