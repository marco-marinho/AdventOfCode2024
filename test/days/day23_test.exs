defmodule AOC2024.Day23Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day23
  alias AOC2024.Input

  test "Day 23 part1 example" do
    capture_io(fn ->
      assert Day23.part1(Input.read_example(23, 1)) == 7
    end)
  end

  test "Day 23 part2 example" do
    capture_io(fn ->
      assert Day23.part2(Input.read_example(23, 1)) == "co,de,ka,ta"
    end)
  end
end
