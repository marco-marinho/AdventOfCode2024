defmodule AOC2024.Day06Test do
  use ExUnit.Case
  alias AOC2024.Day06
  alias AOC2024.Input

  test "Day 06 part1 example" do
    assert Day06.part1(Input.read_example(6, 1)) == 41
  end

  test "Day 06 part2 example" do
    assert Day06.part2(Input.read_example(6, 1)) == 6
  end
end
