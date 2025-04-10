defmodule AOC2024.Day24Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day24
  alias AOC2024.Input

  test "Day 24 part1 example" do
    capture_io(fn ->
      assert Day24.part1(Input.read_example(24, 1)) == 2024
    end)
  end
end
