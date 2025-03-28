defmodule AOC2024.Day08Test do
  use ExUnit.Case
  alias AOC2024.Day08
  alias AOC2024.Input

  test "Day 08 part1 example" do
    assert Day08.part1(Input.read_example(8, 1)) == 14
  end

  test "Day 08 part2 example" do
    assert Day08.part2(Input.read_example(8, 1)) == 34
  end
end
