defmodule AOC2024.Day11Test do
  use ExUnit.Case
  alias AOC2024.Day11
  alias AOC2024.Input

  test "Day 11 part1 example" do
    assert Day11.part1(Input.read_example(11, 1)) == 55312
  end

  test "Day 11 part2 example" do
    assert Day11.part2(Input.read_example(11, 1)) == 65_601_038_650_482
  end
end
