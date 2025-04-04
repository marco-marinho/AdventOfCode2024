defmodule AOC2024.Day06Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day06
  alias AOC2024.Input

  test "Day 06 part1 example" do
    capture_io(fn ->
      assert Day06.part1(Input.read_example(6, 1)) == 41
    end)
  end

  test "Day 06 part2 example" do
    capture_io(fn ->
      assert Day06.part2(Input.read_example(6, 1)) == 6
    end)
  end
end
