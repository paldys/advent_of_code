defmodule AdventOfCode.Puzzles.Day12 do
  @moduledoc """
  --- Day 12: Passage Pathing ---

  With your submarine's subterranean subsystems subsisting suboptimally,
  the only way you're getting out of this cave anytime soon is by finding
  a path yourself. Not just a path - the only way to know if you've found
  the best path is to find all of them.

  Fortunately, the sensors are still mostly working, and so you build
  a rough map of the remaining caves (your puzzle input). For example:

  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end

  This is a list of how all of the caves are connected. You start in the cave
  named start, and your destination is the cave named end. An entry like b-d
  means that cave b is connected to cave d - that is, you can move between them.

  So, the above cave system looks roughly like this:

      start
      /   \
  c--A-----b--d
      \   /
      end

  Your goal is to find the number of distinct paths that start at start, end
  at end, and don't visit small caves more than once. There are two types of
  caves: big caves (written in uppercase, like A) and small caves (written in
  lowercase, like b). It would be a waste of time to visit any small cave more
  than once, but big caves are large enough that it might be worth visiting
  them multiple times. So, all paths you find should visit small caves at most
  once, and can visit big caves any number of times.

  Given these rules, there are 10 paths through this example cave system:

  start,A,b,A,c,A,end
  start,A,b,A,end
  start,A,b,end
  start,A,c,A,b,A,end
  start,A,c,A,b,end
  start,A,c,A,end
  start,A,end
  start,b,A,c,A,end
  start,b,A,end
  start,b,end

  (Each line in the above list corresponds to a single path; the caves visited
  by that path are listed in the order they are visited and separated
  by commas.)

  Note that in this cave system, cave d is never visited by any path: to do so,
  cave b would need to be visited twice (once on the way to cave d and a second
  time when returning from cave d), and since cave b is small, this is not
  allowed.

  Here is a slightly larger example:

  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc

  The 19 paths through it are as follows:

  start,HN,dc,HN,end
  start,HN,dc,HN,kj,HN,end
  start,HN,dc,end
  start,HN,dc,kj,HN,end
  start,HN,end
  start,HN,kj,HN,dc,HN,end
  start,HN,kj,HN,dc,end
  start,HN,kj,HN,end
  start,HN,kj,dc,HN,end
  start,HN,kj,dc,end
  start,dc,HN,end
  start,dc,HN,kj,HN,end
  start,dc,end
  start,dc,kj,HN,end
  start,kj,HN,dc,HN,end
  start,kj,HN,dc,end
  start,kj,HN,end
  start,kj,dc,HN,end
  start,kj,dc,end

  Finally, this even larger example has 226 paths through it:

  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW

  How many paths through this cave system are there that visit small caves
  at most once?

  """
  def load() do
    File.read!("resources/day-12-input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, "-")
      |> List.to_tuple()
    end)
  end

  def solve1(lines) do
    {map, large_caves} = init_map(lines)

    find_all_paths(map, large_caves, :start)
  end

  def solve2(_) do
    nil
  end

  defp find_all_paths(map, large_caves, current_cave, visited_caves \\ MapSet.new()) do
    updated_visited_caves =
      if MapSet.member?(large_caves, current_cave) do
        visited_caves
      else
        MapSet.put(visited_caves, current_cave)
      end

    Map.get(map, current_cave, [])
    |> Enum.filter(fn next_cave -> !MapSet.member?(visited_caves, next_cave) end)
    |> Enum.map(fn next_cave ->
      case next_cave do
        :end -> 1
        _ -> find_all_paths(map, large_caves, next_cave, updated_visited_caves)
      end
    end)
    |> Enum.sum()
  end

  defp init_map(lines, map \\ %{}, large_caves \\ MapSet.new())

  defp init_map([], map, large_caves) do
    {map, large_caves}
  end

  defp init_map([{a, b} | lines], map, large_caves) do
    a_atom = String.to_atom(a)
    b_atom = String.to_atom(b)

    updated_map =
      add_new_path_to_map(map, a_atom, b_atom)
      |> add_new_path_to_map(b_atom, a_atom)

    updated_large_caves =
      add_large_cave(large_caves, a)
      |> add_large_cave(b)

    init_map(lines, updated_map, updated_large_caves)
  end

  defp add_new_path_to_map(map, a, b) do
    Map.update(map, a, [b], &([b | &1]))
  end

  defp add_large_cave(large_caves, cave) do
    if String.upcase(cave) == cave do
      MapSet.put(large_caves, String.to_atom(cave))
    else
      large_caves
    end
  end
end
