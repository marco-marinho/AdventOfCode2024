defmodule Mix.Tasks.Aoc2024.Run do
  use Mix.Task

  @shortdoc "Runs the solution for a specific day and part"

  def run([day_number, part_number]) do
    AOC2024.run(day_number |> String.to_integer(), part_number |> String.to_integer())
  end

  def run(_) do
    IO.puts("Please provide both a day number and a part number")
  end
end
