defmodule AOC2024.Day245est do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day25
  alias AOC2024.Input

  test "Day 25 part1 example" do
    capture_io(fn ->
      assert Day25.part1(Input.read_example(25, 1)) == 3
    end)
  end
end
