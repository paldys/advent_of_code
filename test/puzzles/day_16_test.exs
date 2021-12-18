defmodule AdventOfCode.Puzzles.Day16Test do
  use ExUnit.Case

  test "decode literal" do
    {decoded_packet, _} = AdventOfCode.Puzzles.Day16.decode_packet(Base.decode16!("D2FE28"))
    assert decoded_packet == {:literal, 6, 2021}
  end

  test "decode operator with length" do
    {decoded_packet, _} =
      AdventOfCode.Puzzles.Day16.decode_packet(Base.decode16!("38006F45291200"))

    assert decoded_packet == {:less_than, 1, [{:literal, 2, 20}, {:literal, 6, 10}]}
  end

  test "decode operator with count" do
    {decoded_packet, _} =
      AdventOfCode.Puzzles.Day16.decode_packet(Base.decode16!("EE00D40C823060"))

    assert decoded_packet ==
             {:maximum, 7, [{:literal, 1, 3}, {:literal, 4, 2}, {:literal, 2, 1}]}
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day16.solve1("8A004A801A8002F478") == 16
    assert AdventOfCode.Puzzles.Day16.solve1("620080001611562C8802118E34") == 12
    assert AdventOfCode.Puzzles.Day16.solve1("C0015000016115A2E0802F182340") == 23
    assert AdventOfCode.Puzzles.Day16.solve1("A0016C880162017C3686B18A3D4780") == 31
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day16.solve2("C200B40A82") == 3
    assert AdventOfCode.Puzzles.Day16.solve2("04005AC33890") == 54
    assert AdventOfCode.Puzzles.Day16.solve2("880086C3E88112") == 7
    assert AdventOfCode.Puzzles.Day16.solve2("CE00C43D881120") == 9
    assert AdventOfCode.Puzzles.Day16.solve2("D8005AC2A8F0") == 1
    assert AdventOfCode.Puzzles.Day16.solve2("F600BC2D8F") == 0
    assert AdventOfCode.Puzzles.Day16.solve2("9C005AC2F8F0") == 0
    assert AdventOfCode.Puzzles.Day16.solve2("9C0141080250320F1802104A08") == 1
  end
end
