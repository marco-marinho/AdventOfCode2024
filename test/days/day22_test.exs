defmodule AOC2024.Day22Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day22
  alias AOC2024.Input

  test "Day 22 part1 example" do
    capture_io(fn ->
      assert Day22.part1(Input.read_example(22, 1)) == 37_327_623
    end)
  end

  test "Day 22 part2 example" do
    capture_io(fn ->
      assert Day22.part2(Input.read_example(22, 2)) == 23
    end)
  end
end
