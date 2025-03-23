defmodule AOC2024.Input do
  @input_dir "data/"
  def read(day) do
    File.read("#{@input_dir}day#{day |> Integer.to_string() |> String.pad_leading(2, "0")}.txt")
    |> case do
      {:ok, content} -> String.trim(content) |> String.split("\n") |> Enum.map(&String.trim/1)
      {:error, reason} -> IO.inspect(reason)
    end
  end

  def read_example(day, part) do
    File.read(
      "#{@input_dir}day#{day |> Integer.to_string() |> String.pad_leading(2, "0")}_#{part}_example.txt"
    )
    |> case do
      {:ok, content} -> String.trim(content) |> String.split("\n") |> Enum.map(&String.trim/1)
      {:error, reason} -> IO.inspect(reason)
    end
  end
end
