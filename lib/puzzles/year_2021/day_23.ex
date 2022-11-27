defmodule AdventOfCode.Puzzles.Year2021.Day23 do
  @moduledoc """
  --- Day 23: Amphipod ---

  A group of amphipods notice your fancy submarine and flag you down. "With such
  an impressive shell," one amphipod says, "surely you can help us with
  a question that has stumped our best scientists."

  They go on to explain that a group of timid, stubborn amphipods live in
  a nearby burrow. Four types of amphipods live there: Amber (A), Bronze (B),
  Copper (C), and Desert (D). They live in a burrow that consists of a hallway
  and four side rooms. The side rooms are initially full of amphipods, and
  the hallway is initially empty.

  They give you a diagram of the situation (your puzzle input), including
  locations of each amphipod (A, B, C, or D, each of which is occupying
  an otherwise open space), walls (#), and open space (.).

  For example:

  #############
  #...........#
  ###B#C#B#D###
    #A#D#C#A#
    #########

  The amphipods would like a method to organize every amphipod into side rooms
  so that each side room contains one type of amphipod and the types are sorted
  A-D going left to right, like this:

  #############
  #...........#
  ###A#B#C#D###
    #A#B#C#D#
    #########

  Amphipods can move up, down, left, or right so long as they are moving into
  an unoccupied open space. Each type of amphipod requires a different amount
  of energy to move one step: Amber amphipods require 1 energy per step, Bronze
  amphipods require 10 energy, Copper amphipods require 100, and Desert ones
  require 1000. The amphipods would like you to find a way to organize
  the amphipods that requires the least total energy.

  However, because they are timid and stubborn, the amphipods have some extra rules:

      - Amphipods will never stop on the space immediately outside any room.
      They can move into that space so long as they immediately continue moving.
      (Specifically, this refers to the four open spaces in the hallway that are
      directly above an amphipod starting position.)
      - Amphipods will never move from the hallway into a room unless that room
      is their destination room and that room contains no amphipods which do not
      also have that room as their own destination. If an amphipod's starting
      room is not its destination room, it can stay in that room until it leaves
      the room. (For example, an Amber amphipod will not move from the hallway
      into the right three rooms, and will only move into the leftmost room if
      that room is empty or if it only contains other Amber amphipods.)
      - Once an amphipod stops moving in the hallway, it will stay in that spot
      until it can move into a room. (That is, once any amphipod starts moving,
      any other amphipods currently in the hallway are locked in place and will
      not move again until they can move fully into a room.)

  In the above example, the amphipods can be organized using a minimum of 12521
  energy. One way to do this is shown below.

  Starting configuration:

  #############
  #...........#
  ###B#C#B#D###
    #A#D#C#A#
    #########

  One Bronze amphipod moves into the hallway, taking 4 steps and using 40
  energy:

  #############
  #...B.......#
  ###B#C#.#D###
    #A#D#C#A#
    #########

  The only Copper amphipod not in its side room moves there, taking 4 steps and
  using 400 energy:

  #############
  #...B.......#
  ###B#.#C#D###
    #A#D#C#A#
    #########

  A Desert amphipod moves out of the way, taking 3 steps and using 3000 energy,
  and then the Bronze amphipod takes its place, taking 3 steps and using 30
  energy:

  #############
  #.....D.....#
  ###B#.#C#D###
    #A#B#C#A#
    #########

  The leftmost Bronze amphipod moves to its room using 40 energy:

  #############
  #.....D.....#
  ###.#B#C#D###
    #A#B#C#A#
    #########

  Both amphipods in the rightmost room move into the hallway,
  using 2003 energy in total:

  #############
  #.....D.D.A.#
  ###.#B#C#.###
    #A#B#C#.#
    #########

  Both Desert amphipods move into the rightmost room using 7000 energy:

  #############
  #.........A.#
  ###.#B#C#D###
    #A#B#C#D#
    #########

  Finally, the last Amber amphipod moves into its room, using 8 energy:

  #############
  #...........#
  ###A#B#C#D###
    #A#B#C#D#
    #########

  What is the least energy required to organize the amphipods?

  --- Part Two ---

  As you prepare to give the amphipods your solution, you notice that
  the diagram they handed you was actually folded up. As you unfold it, you
  discover an extra part of the diagram.

  Between the first and second lines of text that contain amphipod starting
  positions, insert the following lines:

    #D#C#B#A#
    #D#B#A#C#

  So, the above example now becomes:

  #############
  #...........#
  ###B#C#B#D###
    #D#C#B#A#
    #D#B#A#C#
    #A#D#C#A#
    #########

  The amphipods still want to be organized into rooms similar to before:

  #############
  #...........#
  ###A#B#C#D###
    #A#B#C#D#
    #A#B#C#D#
    #A#B#C#D#
    #########

  In this updated example, the least energy required to organize these amphipods
  is 44169:

  #############
  #...........#
  ###B#C#B#D###
    #D#C#B#A#
    #D#B#A#C#
    #A#D#C#A#
    #########

  #############
  #..........D#
  ###B#C#B#.###
    #D#C#B#A#
    #D#B#A#C#
    #A#D#C#A#
    #########

  #############
  #A.........D#
  ###B#C#B#.###
    #D#C#B#.#
    #D#B#A#C#
    #A#D#C#A#
    #########

  #############
  #A........BD#
  ###B#C#.#.###
    #D#C#B#.#
    #D#B#A#C#
    #A#D#C#A#
    #########

  #############
  #A......B.BD#
  ###B#C#.#.###
    #D#C#.#.#
    #D#B#A#C#
    #A#D#C#A#
    #########

  #############
  #AA.....B.BD#
  ###B#C#.#.###
    #D#C#.#.#
    #D#B#.#C#
    #A#D#C#A#
    #########

  #############
  #AA.....B.BD#
  ###B#.#.#.###
    #D#C#.#.#
    #D#B#C#C#
    #A#D#C#A#
    #########

  #############
  #AA.....B.BD#
  ###B#.#.#.###
    #D#.#C#.#
    #D#B#C#C#
    #A#D#C#A#
    #########

  #############
  #AA...B.B.BD#
  ###B#.#.#.###
    #D#.#C#.#
    #D#.#C#C#
    #A#D#C#A#
    #########

  #############
  #AA.D.B.B.BD#
  ###B#.#.#.###
    #D#.#C#.#
    #D#.#C#C#
    #A#.#C#A#
    #########

  #############
  #AA.D...B.BD#
  ###B#.#.#.###
    #D#.#C#.#
    #D#.#C#C#
    #A#B#C#A#
    #########

  #############
  #AA.D.....BD#
  ###B#.#.#.###
    #D#.#C#.#
    #D#B#C#C#
    #A#B#C#A#
    #########

  #############
  #AA.D......D#
  ###B#.#.#.###
    #D#B#C#.#
    #D#B#C#C#
    #A#B#C#A#
    #########

  #############
  #AA.D......D#
  ###B#.#C#.###
    #D#B#C#.#
    #D#B#C#.#
    #A#B#C#A#
    #########

  #############
  #AA.D.....AD#
  ###B#.#C#.###
    #D#B#C#.#
    #D#B#C#.#
    #A#B#C#.#
    #########

  #############
  #AA.......AD#
  ###B#.#C#.###
    #D#B#C#.#
    #D#B#C#.#
    #A#B#C#D#
    #########

  #############
  #AA.......AD#
  ###.#B#C#.###
    #D#B#C#.#
    #D#B#C#.#
    #A#B#C#D#
    #########

  #############
  #AA.......AD#
  ###.#B#C#.###
    #.#B#C#.#
    #D#B#C#D#
    #A#B#C#D#
    #########

  #############
  #AA.D.....AD#
  ###.#B#C#.###
    #.#B#C#.#
    #.#B#C#D#
    #A#B#C#D#
    #########

  #############
  #A..D.....AD#
  ###.#B#C#.###
    #.#B#C#.#
    #A#B#C#D#
    #A#B#C#D#
    #########

  #############
  #...D.....AD#
  ###.#B#C#.###
    #A#B#C#.#
    #A#B#C#D#
    #A#B#C#D#
    #########

  #############
  #.........AD#
  ###.#B#C#.###
    #A#B#C#D#
    #A#B#C#D#
    #A#B#C#D#
    #########

  #############
  #..........D#
  ###A#B#C#.###
    #A#B#C#D#
    #A#B#C#D#
    #A#B#C#D#
    #########

  #############
  #...........#
  ###A#B#C#D###
    #A#B#C#D#
    #A#B#C#D#
    #A#B#C#D#
    #########

  Using the initial configuration from the full diagram, what is the least
  energy required to organize the amphipods?
  """
  @empty_hallway '...........'
  # @room_size 2
  # @expected_state ['AA', 'BB', 'CC', 'DD']
  @room_size 4
  @expected_state ['AAAA', 'BBBB', 'CCCC', 'DDDD']
  @energy %{
    ?A => 1,
    ?B => 10,
    ?C => 100,
    ?D => 1000
  }
  @expected_room %{
    ?A => 0,
    ?B => 1,
    ?C => 2,
    ?D => 3
  }
  @hallway_at_room [2, 4, 6, 8]

  @injected_state ['DD', 'CB', 'BA', 'AC']

  def parse(input) do
    [_, _, room_outer, room_inner, _] =
      String.split(input, "\n", trim: true)
      |> Enum.map(fn line ->
        String.replace(line, ["#", " "], "")
        |> String.to_charlist()
      end)

    Enum.zip_with(room_outer, room_inner, fn o, i -> [o, i] end)
  end

  def solve1(initial) do
    find_most_optimal(initial)
  end

  def solve2(initial) do
    Enum.zip_with(initial, @injected_state, fn [a1, a4], [a2, a3] -> [a1, a2, a3, a4] end)
    |> find_most_optimal()
  end

  defp find_most_optimal(
         rooms,
         hallway \\ @empty_hallway,
         cost \\ 0,
         potential_cost \\ 0,
         most_optimal_so_far \\ nil
       )

  defp find_most_optimal(_, _, cost, potential_cost, most_optimal_so_far)
       when cost + potential_cost >= most_optimal_so_far,
       do: :non_optimal

  defp find_most_optimal(@expected_state, @empty_hallway, cost, _, _), do: cost

  defp find_most_optimal(rooms, hallway, cost, potential_cost, most_optimal_so_far) do
    case find_valid_moves(rooms, hallway) do
      [] ->
        :lock

      moves ->
        Enum.reduce(moves, most_optimal_so_far, fn {rooms, hallway, move_cost,
                                                    move_potential_cost},
                                                   min ->
          case find_most_optimal(
                 rooms,
                 hallway,
                 cost + move_cost,
                 potential_cost + move_potential_cost,
                 min
               ) do
            :lock -> min
            :non_optimal -> min
            possible_min -> min(possible_min, min)
          end
        end)
    end
  end

  defp find_valid_moves(rooms, hallway) do
    moves_to_room =
      Enum.with_index(hallway)
      |> Enum.filter(fn {in_hallway, _} ->
        in_hallway != ?.
      end)
      |> Enum.flat_map(fn {amphipod, i} ->
        room_index = Map.get(@expected_room, amphipod)
        expected_room = Enum.at(rooms, room_index)

        room_hallway_index = room_to_hallway(room_index)

        path_to_room =
          if i < room_hallway_index do
            Enum.slice(hallway, (i + 1)..room_hallway_index)
          else
            Enum.slice(hallway, room_hallway_index..(i - 1))
          end

        can_enter_room =
          Enum.all?(expected_room, fn amphipod_in_room -> amphipod_in_room == amphipod end)

        can_go_to_room = Enum.all?(path_to_room, &(&1 == ?.))

        if can_enter_room and can_go_to_room do
          updated_rooms =
            List.update_at(rooms, room_index, fn in_room -> [amphipod | in_room] end)

          updated_hallway = List.replace_at(hallway, i, ?.)

          move_cost = Map.get(@energy, amphipod)

          [
            {updated_rooms, updated_hallway,
             (length(path_to_room) + @room_size - length(expected_room)) * move_cost,
             -(length(path_to_room) + 1) * move_cost}
          ]
        else
          []
        end
      end)

    moves_from_room =
      Enum.with_index(rooms)
      |> Enum.filter(fn {room, _} ->
        length(room) > 0
      end)
      |> Enum.filter(fn {room, i} ->
        amphipod = hd(room)
        room_index = Map.get(@expected_room, amphipod)
        room_index != i || !Enum.all?(room, &(&1 == amphipod))
      end)
      |> Enum.flat_map(fn {[amphipod | rest_of_room], i} ->
        hallway_index = room_to_hallway(i)
        move_cost = Map.get(@energy, amphipod)
        out_of_room_cost = (@room_size - length(rest_of_room)) * move_cost

        updated_rooms = List.replace_at(rooms, i, rest_of_room)

        move_to_left =
          Enum.take_while((hallway_index - 1)..0, fn i ->
            Enum.at(hallway, i) == ?.
          end)
          |> Enum.reject(fn i -> Enum.member?(@hallway_at_room, i) end)
          |> Enum.map(fn i ->
            updated_hallway = List.replace_at(hallway, i, amphipod)
            in_hallway_cost = (hallway_index - i) * move_cost

            potential_cost =
              (room_to_hallway(Map.get(@expected_room, amphipod)) - i + 1) * move_cost

            {updated_rooms, updated_hallway, out_of_room_cost + in_hallway_cost, potential_cost}
          end)

        move_to_right =
          Enum.take_while((hallway_index + 1)..10, fn i ->
            Enum.at(hallway, i) == ?.
          end)
          |> Enum.reject(fn i -> Enum.member?(@hallway_at_room, i) end)
          |> Enum.map(fn i ->
            updated_hallway = List.replace_at(hallway, i, amphipod)
            in_hallway_cost = (i - hallway_index) * move_cost

            potential_cost =
              (room_to_hallway(Map.get(@expected_room, amphipod)) - i + 1) * move_cost

            {updated_rooms, updated_hallway, out_of_room_cost + in_hallway_cost, potential_cost}
          end)

        move_to_left ++ move_to_right
      end)

    moves_to_room ++ moves_from_room
  end

  defp room_to_hallway(i), do: i * 2 + 2
end
