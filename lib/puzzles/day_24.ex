defmodule AdventOfCode.Puzzles.Day24 do
  @moduledoc """
  --- Day 24: Arithmetic Logic Unit ---

  Magic smoke starts leaking from the submarine's arithmetic logic unit (ALU).
  Without the ability to perform basic arithmetic and logic functions,
  the submarine can't produce cool patterns with its Christmas lights!

  It also can't navigate. Or run the oxygen system.

  Don't worry, though - you probably have enough oxygen left to give you enough
  time to build a new ALU.

  The ALU is a four-dimensional processing unit: it has integer variables w, x,
  y, and z. These variables all start with the value 0. The ALU also supports
  six instructions:

      - inp a - Read an input value and write it to variable a.
      - add a b - Add the value of a to the value of b, then store the result
      in variable a.
      - mul a b - Multiply the value of a by the value of b, then store
      the result in variable a.
      - div a b - Divide the value of a by the value of b, truncate the result
      to an integer, then store the result in variable a. (Here, "truncate"
      means to round the value toward zero.)
      - mod a b - Divide the value of a by the value of b, then store
      the remainder in variable a. (This is also called the modulo operation.)
      - eql a b - If the value of a and b are equal, then store the value 1
      in variable a. Otherwise, store the value 0 in variable a.

  In all of these instructions, a and b are placeholders; a will always be
  the variable where the result of the operation is stored (one of w, x, y,
  or z), while b can be either a variable or a number. Numbers can be positive
  or negative, but will always be integers.

  The ALU has no jump instructions; in an ALU program, every instruction is run
  exactly once in order from top to bottom. The program halts after
    the last instruction has finished executing.

  (Program authors should be especially cautious; attempting to execute div
  with b=0 or attempting to execute mod with a<0 or b<=0 will cause the program
  to crash and might even damage the ALU. These operations are never intended
  in any serious ALU program.)

  For example, here is an ALU program which takes an input number, negates it,
  and stores it in x:

  inp x
  mul x -1

  Here is an ALU program which takes two input numbers, then sets z to 1 if
  the second input number is three times larger than the first input number,
  or sets z to 0 otherwise:

  inp z
  inp x
  mul z 3
  eql z x

  Here is an ALU program which takes a non-negative integer as input, converts
  it into binary, and stores the lowest (1's) bit in z, the second-lowest (2's)
  bit in y, the third-lowest (4's) bit in x, and the fourth-lowest (8's) bit
  in w:

  inp w
  add z w
  mod z 2
  div w 2
  add y w
  mod y 2
  div w 2
  add x w
  mod x 2
  div w 2
  mod w 2

  Once you have built a replacement ALU, you can install it in the submarine,
  which will immediately resume what it was doing when the ALU failed:
  validating the submarine's model number. To do this, the ALU will run
  the MOdel Number Automatic Detector program (MONAD, your puzzle input).

  Submarine model numbers are always fourteen-digit numbers consisting only
  of digits 1 through 9. The digit 0 cannot appear in a model number.

  When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen
  separate inp instructions, each expecting a single digit of the model number
  in order of most to least significant. (So, to check the model number
  13579246899999, you would give 1 to the first inp instruction, 3 to
  the second inp instruction, 5 to the third inp instruction, and so on.)
  This means that when operating MONAD, each input instruction should only ever
  be given an integer value of at least 1 and at most 9.

  Then, after MONAD has finished running all of its instructions, it will
  indicate that the model number was valid by leaving a 0 in variable z. However
  , if the model number was invalid, it will leave some other non-zero value
  in z.

  MONAD imposes additional, mysterious restrictions on model numbers, and legend
  says the last copy of the MONAD documentation was eaten by a tanuki. You'll
  need to figure out what MONAD does some other way.

  To enable as many submarine features as possible, find the largest valid
  fourteen-digit model number that contains no 0 digits. What is
  the largest model number accepted by MONAD?

  --- Part Two ---

  As the submarine starts booting up things like the Retro Encabulator, you
  realize that maybe you don't need all these submarine features after all.

  What is the smallest model number accepted by MONAD?
  """
  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(fn v ->
        if Regex.match?(~r/^-?[[:digit:]]+$/, v) do
          String.to_integer(v)
        else
          String.to_atom(v)
        end
      end)
      |> List.to_tuple()
    end)
  end

  def solve1(instructions) do
    evaluation_tree(instructions)
    |> Enum.map(&Map.get(&1, :z))
    |> find_model_number()
    |> Enum.join()
  end

  def solve2(instructions) do
    evaluation_tree(instructions)
    |> Enum.map(&Map.get(&1, :z))
    |> find_model_number(1..9)
    |> Enum.join()
  end

  defp evaluation_tree(
         instructions,
         variables \\ %{w: {:literal, 0}, x: {:literal, 0}, y: {:literal, 0}, z: {:literal, 0}},
         prev_variables \\ []
       )

  defp evaluation_tree([], variables, prev_variables),
    do: Enum.reverse([variables | prev_variables]) |> tl()

  defp evaluation_tree([{:inp, reg} | rest], variables, prev_variables) do
    prev_variables = [variables | prev_variables]

    variables =
      Enum.map(variables, fn {k, v} ->
        cond do
          k == reg -> {k, {:input}}
          elem(v, 0) == :literal -> {k, v}
          true -> {k, {:prev, k}}
        end
      end)
      |> Map.new()

    evaluation_tree(rest, variables, prev_variables)
  end

  defp evaluation_tree([{operator, reg, reg_or_val} | rest], variables, prev_variables) do
    right =
      if is_atom(reg_or_val), do: Map.get(variables, reg_or_val), else: {:literal, reg_or_val}

    variables =
      Map.update!(variables, reg, fn left ->
        case {operator, left, right} do
          {operator, {:literal, left_value}, {:literal, right_value}} ->
            {:literal, evaluate_operation(operator, left_value, right_value)}

          {:mul, {:literal, 0}, _} ->
            {:literal, 0}

          {:mul, _, {:literal, 0}} ->
            {:literal, 0}

          {:mul, {:literal, 1}, right} ->
            right

          {:mul, left, {:literal, 1}} ->
            left

          {:add, {:literal, 0}, right} ->
            right

          {:add, left, {:literal, 0}} ->
            left

          {:div, left, {:literal, 1}} ->
            left

          {:eql, {:eql, left, right}, {:literal, 0}} ->
            {:neql, left, right}

          {:eql, {:literal, v}, {:input}} when v > 9 ->
            {:literal, 0}

          {:neql, {:literal, v}, {:input}} when v > 9 ->
            {:literal, 1}

          {operator, left, right} ->
            {operator, left, right}
        end
      end)

    evaluation_tree(rest, variables, prev_variables)
  end

  defp evaluate_operation(operator, left, right) do
    case operator do
      :add -> left + right
      :mul -> left * right
      :div -> div(left, right)
      :mod -> rem(left, right)
      :eql -> if left == right, do: 1, else: 0
      :neql -> if left != right, do: 1, else: 0
    end
  end

  defp find_model_number(
         [evaluation_tree | rest],
         input_range \\ 9..1,
         z \\ 0,
         depth \\ 0,
         cache \\ MapSet.new()
       ) do
    if MapSet.member?(cache, {depth, z}) do
      {:invalid, cache}
    else
      Enum.reduce_while(input_range, {:invalid, cache}, fn n, {:invalid, cache} ->
        new_z = evaluate_tree(evaluation_tree, z, n)

        case rest do
          [] ->
            if new_z == 0, do: {:halt, [n]}, else: {:cont, {:invalid, cache}}

          _ ->
            case find_model_number(rest, input_range, new_z, depth + 1, cache) do
              {:invalid, cache} -> {:cont, {:invalid, MapSet.put(cache, {depth + 1, new_z})}}
              model_number -> {:halt, [n | model_number]}
            end
        end
      end)
    end
  end

  def evaluate_tree(operation, prev_z, input) do
    case operation do
      {:input} ->
        input

      {:prev, :z} ->
        prev_z

      {:literal, v} ->
        v

      {operator, left, right} ->
        left_value = evaluate_tree(left, prev_z, input)
        right_value = evaluate_tree(right, prev_z, input)

        case operator do
          :add -> left_value + right_value
          :mul -> left_value * right_value
          :div -> div(left_value, right_value)
          :mod -> rem(left_value, right_value)
          :eql -> if left_value == right_value, do: 1, else: 0
          :neql -> if left_value != right_value, do: 1, else: 0
        end
    end
  end
end
