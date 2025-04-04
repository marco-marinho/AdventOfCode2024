defmodule AOC2024.Day18Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day18
  alias AOC2024.Input

  test "Day 18 part1 example" do
    capture_io(fn ->
      assert Day18.part1(Input.read_example(18, 1)) == 354
    end)
  end

  test "Day 18 part2 example" do
    capture_io(fn ->
      assert Day18.part2(Input.read_example(18, 1)) == {36, 17}
    end)
  end
end
