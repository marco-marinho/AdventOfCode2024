defmodule AOC2024.Day13Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day13
  alias AOC2024.Input

  test "Day 13 part1 example" do
    capture_io(fn ->
      assert Day13.part1(Input.read_example(13, 1)) == 480
    end)
  end

  test "Day 13 part2 example" do
    capture_io(fn ->
      assert Day13.part2(Input.read_example(13, 1)) == 875_318_608_908
    end)
  end
end
