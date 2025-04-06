defmodule AOC2024.Day21Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AOC2024.Day21
  alias AOC2024.Input

  test "Day 21 part1 example" do
    capture_io(fn ->
      assert Day21.part1(Input.read_example(21, 1)) == 126_384
    end)
  end

  test "Day 20 part2 example" do
    capture_io(fn ->
      assert Day21.part2(Input.read_example(21, 1)) == 154_115_708_116_294
    end)
  end
end
