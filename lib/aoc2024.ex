defmodule AOC2024 do
  def run(day, part) do
    input = AOC2024.Input.read(day)
    module = Module.concat(AOC2024, "Day#{String.pad_leading(Integer.to_string(day), 2, "0")}")

    case part do
      1 -> module.part1(input)
      2 -> module.part2(input)
      _ -> {:error, "Invalid part"}
    end
  end
end
