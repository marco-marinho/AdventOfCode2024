defmodule AOC2024.Day04Test do
  use ExUnit.Case
  alias AOC2024.Day04
  alias AOC2024.Input

  test "Day 04 part1 example" do
    assert Day04.part1(Input.read_example(4, 1)) == 18
  end

  test "Day 04 part2 example" do
    assert Day04.part2(Input.read_example(4, 1)) == 9
  end
end
