defmodule AOC2024.Day02Test do
  use ExUnit.Case
  alias AOC2024.Day02
  alias AOC2024.Input

  test "Day 02 part1 example" do
    assert Day02.part1(Input.read_example(2, 1)) == 2
  end

  test "Day 02 part2 example" do
    assert Day02.part2(Input.read_example(2, 1)) == 4
  end
end
