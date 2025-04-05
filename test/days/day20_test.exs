defmodule AOC2024.Day20Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day20
  alias AOC2024.Input

  test "Day 20 part1 example" do
    capture_io(fn ->
      assert Day20.part1(Input.read_example(20, 1)) == 1524
    end)
  end

  test "Day 20 part2 example" do
    capture_io(fn ->
      assert Day20.part2(Input.read_example(20, 1)) == 1_033_746
    end)
  end
end
