defmodule AOC2024.Day09Test do
  use ExUnit.Case
  alias AOC2024.Day09
  alias AOC2024.Input

  test "Day 09 part1 example" do
    assert Day09.part1(Input.read_example(9, 1)) == 1928
  end

  test "Day 09 part2 example" do
    assert Day09.part2(Input.read_example(9, 1)) == 2858
  end
end
