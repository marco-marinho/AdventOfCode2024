defmodule AOC2024.Day24Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day24
  alias AOC2024.Input

  test "Day 24 part1 example" do
    # capture_io(fn ->
      assert Day24.part1(Input.read_example(24, 1)) == 2024
    # end)
  end

  # test "Day 23 part2 example" do
  #   capture_io(fn ->
  #     assert Day23.part2(Input.read_example(23, 1)) == "co,de,ka,ta"
  #   end)
  # end
end
