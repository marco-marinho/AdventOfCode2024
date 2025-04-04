defmodule AOC2024.Day17Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day17
  alias AOC2024.Input

  test "Day 17 part1 example" do
    capture_io(fn ->
    assert Day17.part1(Input.read_example(17, 1)) == "1,7,2,1,4,1,5,4,0"
    end)
  end

  test "Day 17 part2 example" do
    capture_io(fn ->
    assert Day17.part2(Input.read_example(17, 1)) == 37221261688308
  end)
  end
end
