defmodule AOC2024.Day17 do
  import Bitwise
  def get_combo(operand, regs) do
    case operand do
      n when n in 0..3 -> n
      4 -> regs["A"]
      5 -> regs["B"]
      6 -> regs["C"]
      7 -> raise "Invalid operand"
    end
  end

  def xdv(operand, {ip, regs, output}, oreg) do
    numerator = Map.get(regs, "A")
    denominator = :math.pow(2, get_combo(operand, regs))
    {ip + 2, Map.put(regs, oreg, trunc(numerator / denominator)), output}
  end

  def adv(operand, state) do
    xdv(operand, state, "A")
  end

  def bdv(operand, state) do
    xdv(operand, state, "B")
  end

  def cdv(operand, state) do
    xdv(operand, state, "C")
  end

  def bxl(operand, {ip, regs, output}) do
    res = Bitwise.bxor(operand, Map.get(regs, "B"))
    {ip + 2, Map.put(regs, "B", res), output}
  end

  def bst(operand, {ip, regs, output}) do
    {ip + 2, Map.put(regs, "B", rem(get_combo(operand, regs), 8)), output}
  end

  def jnz(operand, {ip, regs, output}) do
    if Map.get(regs, "A") != 0 do
      {operand, regs, output}
    else
      {ip + 2, regs, output}
    end
  end

  def bxc(_, {ip, regs, output}) do
    res = Bitwise.bxor(Map.get(regs, "B"), Map.get(regs, "C"))
    {ip + 2, Map.put(regs, "B", res), output}
  end

  def out(operand, {ip, regs, output}) do
    res = rem(get_combo(operand, regs), 8)
    {ip + 2, regs, [res | output]}
  end

  def run(program, state) do
    {ip, regs, output} = state

    if ip >= tuple_size(program) do
      {ip, regs, Enum.reverse(output)}
    else
      {curr, next} = {elem(program, ip), elem(program, ip + 1)}
      next_state =
      case curr do
        0 -> adv(next, state)
        1 -> bxl(next, state)
        2 -> bst(next, state)
        3 -> jnz(next, state)
        4 -> bxc(next, state)
        5 -> out(next, state)
        6 -> bdv(next, state)
        7 -> cdv(next, state)
      end
      run(program, next_state)
    end
  end

  def compiled(a_value) do
    a = Bitwise.bxor(rem(a_value, 8), 2)
    b = a_value >>> Bitwise.bxor(rem(a_value, 8), 2)
    c = Bitwise.bxor(a, b)
    {rem(Bitwise.bxor(c, 3), 8), a_value >>> 3}
  end

  def parse(input) do
    reg_vals = input |> Enum.take(3) |> Enum.map(fn x -> String.split(x, ": ") |> Enum.at(1) |> String.to_integer() end)
    regs = %{"A" => Enum.at(reg_vals, 0), "B" => Enum.at(reg_vals, 1), "C" => Enum.at(reg_vals, 2)}
    program = input |> Enum.at(4) |> String.split(": ") |> Enum.at(1) |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    {program, {0, regs, []}}
  end

  def run_compiled(value, acc) do
    if value == 0 do
      Enum.reverse(acc)
    else
      {a, b} = compiled(value)
      run_compiled(b, [a | acc])
    end
  end

  def dfs(value, idx, lookup, acc) when idx > length(lookup) do
    [value | acc]
  end

  def dfs(value, idx, lookup, acc) do
    Enum.reduce(0..7, acc, fn i, iacc ->
      new_value = (value <<< 3) + i
      res = run_compiled(new_value, [])
      if res == Enum.take(lookup, idx) |> Enum.reverse() do
        dfs(new_value, idx + 1, lookup, iacc)
      else
        iacc
      end
    end)
  end

  def part1(input) do
    {program, state} = parse(input)
    {_, _, output} = run(program, state)
    Enum.join(Enum.map(output, &Integer.to_string(&1)), ",") |> IO.inspect()
  end

  def part2(input) do
    {program, _} = parse(input)
    lookup = Enum.reverse(Tuple.to_list(program))
    dfs(0, 1, lookup, []) |> Enum.min() |> IO.inspect()
  end

end
