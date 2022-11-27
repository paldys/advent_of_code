defmodule AdventOfCode.Puzzles.Year2021.Day14 do
  @moduledoc """
  --- Day 14: Extended Polymerization ---

  The incredible pressures at this depth are starting to put a strain on your
  submarine. The submarine has polymerization equipment that would produce
  suitable materials to reinforce the submarine, and the nearby
  volcanically-active caves should even have the necessary input elements
  in sufficient quantities.

  The submarine manual contains instructions for finding the optimal polymer
  formula; specifically, it offers a polymer template and a list of pair
  insertion rules (your puzzle input). You just need to work out what polymer
   would result after repeating the pair insertion process a few times.

  For example:

  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C

  The first line is the polymer template - this is the starting point
  of the process.

  The following section defines the pair insertion rules. A rule like AB -> C
  means that when elements A and B are immediately adjacent, element C
  should be inserted between them. These insertions all happen simultaneously.

  So, starting with the polymer template NNCB, the first step simultaneously
  considers all three pairs:

      - The first pair (NN) matches the rule NN -> C, so element C is inserted
      between the first N and the second N.
      - The second pair (NC) matches the rule NC -> B, so element B is inserted
      between the N and the C.
      - The third pair (CB) matches the rule CB -> H, so element H is
      inserted between the C and the B.

  Note that these pairs overlap: the second element of one pair is the first
  element of the next pair. Also, because all pairs are considered
  simultaneously, inserted elements are not considered to be part of a pair
  until the next step.

  After the first step of this process, the polymer becomes NCNBCHB.

  Here are the results of a few steps using the above rules:

  Template:     NNCB
  After step 1: NCNBCHB
  After step 2: NBCCNBBBCBHCB
  After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
  After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB

  This polymer grows quickly. After step 5, it has length 97; After step 10, it
  has length 3073. After step 10, B occurs 1749 times, C occurs 298 times,
  H occurs 161 times, and N occurs 865 times; taking the quantity of the most
  common element (B, 1749) and subtracting the quantity of the least common
  element (H, 161) produces 1749 - 161 = 1588.

  Apply 10 steps of pair insertion to the polymer template and find the most and
  least common elements in the result. What do you get if you take the quantity
  of the most common element and subtract the quantity
  of the least common element?

  --- Part Two ---

  The resulting polymer isn't nearly strong enough to reinforce the submarine.
  You'll need to run more steps of the pair insertion process; a total of 40
  steps should do it.

  In the above example, the most common element is B (occurring 2192039569602
  times) and the least common element is H (occurring 3849876073 times);
  subtracting these produces 2188189693529.

  Apply 40 steps of pair insertion to the polymer template and find the most and
  least common elements in the result. What do you get if you take the quantity
  of the most common element and subtract the quantity of the least common
  element?
  """
  def parse(input) do
    [template_str | raw_rules] = String.split(input, "\n", trim: true)

    template = String.to_charlist(template_str)

    rules =
      Map.new(raw_rules, fn raw_rule ->
        [rule_key, [rule_value]] =
          String.split(raw_rule, " -> ")
          |> Enum.map(&String.to_charlist/1)

        {rule_key, rule_value}
      end)

    {template, rules}
  end

  def solve1({template, rules}, steps \\ 10) do
    template_pairs =
      Enum.chunk_every(template, 2, 1, :discard)
      |> Enum.reduce(%{}, fn pair, template_pairs ->
        Map.update(template_pairs, pair, 1, &(&1 + 1))
      end)

    double_char_count =
      apply_insertions(template_pairs, rules, steps)
      |> Enum.reduce(%{}, fn {[c1, c2], count}, double_char_count ->
        Map.update(double_char_count, c1, count, &(&1 + count))
        |> Map.update(c2, count, &(&1 + count))
      end)
      |> Map.update(hd(template), 1, &(&1 + 1))
      |> Map.update(List.last(template), 1, &(&1 + 1))

    most_common = Map.values(double_char_count) |> Enum.max()
    least_common = Map.values(double_char_count) |> Enum.min()

    div(most_common - least_common + 1, 2)
  end

  def solve2(template_and_rules) do
    solve1(template_and_rules, 40)
  end

  defp apply_insertions(template_pairs, _, 0), do: template_pairs

  defp apply_insertions(template_pairs, rules, step) do
    new_template_pairs =
      Enum.reduce(template_pairs, %{}, fn {pair, count}, new_template_pairs ->
        new_char = Map.get(rules, pair)
        [c1, c2] = pair

        Map.update(new_template_pairs, [c1, new_char], count, &(&1 + count))
        |> Map.update([new_char, c2], count, &(&1 + count))
      end)

    apply_insertions(new_template_pairs, rules, step - 1)
  end
end
