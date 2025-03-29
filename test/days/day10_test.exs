defmodule AOC2024.Day10Test do
  use ExUnit.Case
  alias AOC2024.Day10
  alias AOC2024.Input

  test "Day 10 part1 example" do
    assert Day10.part1(Input.read_example(10, 1)) == 36
  end

  test "Day 10 part2 example" do
    assert Day10.part2(Input.read_example(10, 1)) == 81
  end
end
