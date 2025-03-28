Benchee.run(
  %{
    "Part 2" => fn -> AOC2024.run(6, 2) end,
  },
  time: 10,  # Run each benchmark for 10 seconds
  memory_time: 2,
  reduction_time: 2,
  print: [
    fast_warning: false,
    configuration: true,
    memory: true
  ],
  profile_after: true
)
