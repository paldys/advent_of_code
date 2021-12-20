defmodule AdventOfCode.Puzzles.Day19 do
  @moduledoc """
  --- Day 19: Beacon Scanner ---

  As your probe drifted down through this area, it released an assortment of
  beacons and scanners into the water. It's difficult to navigate in the pitch
  black open waters of the ocean trench, but if you can build a map of
  the trench using data from the scanners, you should be able to safely reach
  the bottom.

  The beacons and scanners float motionless in the water; they're designed
  to maintain the same position for long periods of time. Each scanner is
  capable of detecting all beacons in a large cube centered on the scanner;
  beacons that are at most 1000 units away from the scanner in each of
  the three axes (x, y, and z) have their precise position determined relative
  to the scanner. However, scanners cannot detect other scanners. The submarine
  has automatically summarized the relative positions of beacons detected
  by each scanner (your puzzle input).

  For example, if a scanner is at x,y,z coordinates 500,0,-500 and there are
  beacons at -500,1000,-1500 and 1501,0,-500, the scanner could report that
  the first beacon is at -1000,1000,-1000 (relative to the scanner) but would
  not detect the second beacon at all.

  Unfortunately, while each scanner can report the positions of all detected
  beacons relative to itself, the scanners do not know their own position.
  You'll need to determine the positions of the beacons and scanners yourself.

  The scanners and beacons map a single contiguous 3d region. This region can
  be reconstructed by finding pairs of scanners that have overlapping detection
  regions such that there are at least 12 beacons that both scanners detect
  within the overlap. By establishing 12 common beacons, you can precisely
  determine where the scanners are relative to each other, allowing you to
  reconstruct the beacon map one scanner at a time.

  For a moment, consider only two dimensions. Suppose you have the following
  scanner reports:

  --- scanner 0 ---
  0,2
  4,1
  3,3

  --- scanner 1 ---
  -1,-1
  -5,0
  -2,1

  Drawing x increasing rightward, y increasing upward, scanners as S, and
  beacons as B, scanner 0 detects this:

  ...B.
  B....
  ....B
  S....

  Scanner 1 detects this:

  ...B..
  B....S
  ....B.

  For this example, assume scanners only need 3 overlapping beacons. Then,
  the beacons visible to both scanners overlap to produce the following complete
  map:

  ...B..
  B....S
  ....B.
  S.....

  Unfortunately, there's a second problem: the scanners also don't know their
  rotation or facing direction. Due to magnetic alignment, each scanner is
  rotated some integer number of 90-degree turns around all of the x, y, and z
  axes. That is, one scanner might call a direction positive x, while another
  scanner might call that direction negative y. Or, two scanners might agree
  on which direction is positive x, but one scanner might be upside-down from
  the perspective of the other scanner. In total, each scanner could be in any
  of 24 different orientations: facing positive or negative x, y, or z, and
  considering any of four directions "up" from that facing.

  For example, here is an arrangement of beacons as seen from a scanner in
  the same position but in different orientations:

  --- scanner 0 ---
  -1,-1,1
  -2,-2,2
  -3,-3,3
  -2,-3,1
  5,6,-4
  8,0,7

  --- scanner 0 ---
  1,-1,1
  2,-2,2
  3,-3,3
  2,-1,3
  -5,4,-6
  -8,-7,0

  --- scanner 0 ---
  -1,-1,-1
  -2,-2,-2
  -3,-3,-3
  -1,-3,-2
  4,6,5
  -7,0,8

  --- scanner 0 ---
  1,1,-1
  2,2,-2
  3,3,-3
  1,3,-2
  -4,-6,5
  7,0,8

  --- scanner 0 ---
  1,1,1
  2,2,2
  3,3,3
  3,1,2
  -6,-4,-5
  0,7,-8

  By finding pairs of scanners that both see at least 12 of the same beacons,
  you can assemble the entire map. For example, consider the following report:

  --- scanner 0 ---
  404,-588,-901
  528,-643,409
  -838,591,734
  390,-675,-793
  -537,-823,-458
  -485,-357,347
  -345,-311,381
  -661,-816,-575
  -876,649,763
  -618,-824,-621
  553,345,-567
  474,580,667
  -447,-329,318
  -584,868,-557
  544,-627,-890
  564,392,-477
  455,729,728
  -892,524,684
  -689,845,-530
  423,-701,434
  7,-33,-71
  630,319,-379
  443,580,662
  -789,900,-551
  459,-707,401

  --- scanner 1 ---
  686,422,578
  605,423,415
  515,917,-361
  -336,658,858
  95,138,22
  -476,619,847
  -340,-569,-846
  567,-361,727
  -460,603,-452
  669,-402,600
  729,430,532
  -500,-761,534
  -322,571,750
  -466,-666,-811
  -429,-592,574
  -355,545,-477
  703,-491,-529
  -328,-685,520
  413,935,-424
  -391,539,-444
  586,-435,557
  -364,-763,-893
  807,-499,-711
  755,-354,-619
  553,889,-390

  --- scanner 2 ---
  649,640,665
  682,-795,504
  -784,533,-524
  -644,584,-595
  -588,-843,648
  -30,6,44
  -674,560,763
  500,723,-460
  609,671,-379
  -555,-800,653
  -675,-892,-343
  697,-426,-610
  578,704,681
  493,664,-388
  -671,-858,530
  -667,343,800
  571,-461,-707
  -138,-166,112
  -889,563,-600
  646,-828,498
  640,759,510
  -630,509,768
  -681,-892,-333
  673,-379,-804
  -742,-814,-386
  577,-820,562

  --- scanner 3 ---
  -589,542,597
  605,-692,669
  -500,565,-823
  -660,373,557
  -458,-679,-417
  -488,449,543
  -626,468,-788
  338,-750,-386
  528,-832,-391
  562,-778,733
  -938,-730,414
  543,643,-506
  -524,371,-870
  407,773,750
  -104,29,83
  378,-903,-323
  -778,-728,485
  426,699,580
  -438,-605,-362
  -469,-447,-387
  509,732,623
  647,635,-688
  -868,-804,481
  614,-800,639
  595,780,-596

  --- scanner 4 ---
  727,592,562
  -293,-554,779
  441,611,-461
  -714,465,-776
  -743,427,-804
  -660,-479,-426
  832,-632,460
  927,-485,-438
  408,393,-506
  466,436,-512
  110,16,151
  -258,-428,682
  -393,719,612
  -211,-452,876
  808,-476,-593
  -575,615,604
  -485,667,467
  -680,325,-822
  -627,-443,-432
  872,-547,-609
  833,512,582
  807,604,487
  839,-516,451
  891,-625,532
  -652,-548,-490
  30,-46,-14

  Because all coordinates are relative, in this example, all "absolute"
  positions will be expressed relative to scanner 0 (using the orientation of
  scanner 0 and as if scanner 0 is at coordinates 0,0,0).

  Scanners 0 and 1 have overlapping detection cubes; the 12 beacons they both
  detect (relative to scanner 0) are at the following coordinates:

  -618,-824,-621
  -537,-823,-458
  -447,-329,318
  404,-588,-901
  544,-627,-890
  528,-643,409
  -661,-816,-575
  390,-675,-793
  423,-701,434
  -345,-311,381
  459,-707,401
  -485,-357,347

  These same 12 beacons (in the same order) but from the perspective of scanner
  1 are:

  686,422,578
  605,423,415
  515,917,-361
  -336,658,858
  -476,619,847
  -460,603,-452
  729,430,532
  -322,571,750
  -355,545,-477
  413,935,-424
  -391,539,-444
  553,889,-390

  Because of this, scanner 1 must be at 68,-1246,-43 (relative to scanner 0).

  Scanner 4 overlaps with scanner 1; the 12 beacons they both detect
  (relative to scanner 0) are:

  459,-707,401
  -739,-1745,668
  -485,-357,347
  432,-2009,850
  528,-643,409
  423,-701,434
  -345,-311,381
  408,-1815,803
  534,-1912,768
  -687,-1600,576
  -447,-329,318
  -635,-1737,486

  So, scanner 4 is at -20,-1133,1061 (relative to scanner 0).

  Following this process, scanner 2 must be at 1105,-1205,1229 (relative to
  scanner 0) and scanner 3 must be at -92,-2380,-20 (relative to scanner 0).

  The full list of beacons (relative to scanner 0) is:

  -892,524,684
  -876,649,763
  -838,591,734
  -789,900,-551
  -739,-1745,668
  -706,-3180,-659
  -697,-3072,-689
  -689,845,-530
  -687,-1600,576
  -661,-816,-575
  -654,-3158,-753
  -635,-1737,486
  -631,-672,1502
  -624,-1620,1868
  -620,-3212,371
  -618,-824,-621
  -612,-1695,1788
  -601,-1648,-643
  -584,868,-557
  -537,-823,-458
  -532,-1715,1894
  -518,-1681,-600
  -499,-1607,-770
  -485,-357,347
  -470,-3283,303
  -456,-621,1527
  -447,-329,318
  -430,-3130,366
  -413,-627,1469
  -345,-311,381
  -36,-1284,1171
  -27,-1108,-65
  7,-33,-71
  12,-2351,-103
  26,-1119,1091
  346,-2985,342
  366,-3059,397
  377,-2827,367
  390,-675,-793
  396,-1931,-563
  404,-588,-901
  408,-1815,803
  423,-701,434
  432,-2009,850
  443,580,662
  455,729,728
  456,-540,1869
  459,-707,401
  465,-695,1988
  474,580,667
  496,-1584,1900
  497,-1838,-617
  527,-524,1933
  528,-643,409
  534,-1912,768
  544,-627,-890
  553,345,-567
  564,392,-477
  568,-2007,-577
  605,-1665,1952
  612,-1593,1893
  630,319,-379
  686,-3108,-505
  776,-3184,-501
  846,-3110,-434
  1135,-1161,1235
  1243,-1093,1063
  1660,-552,429
  1693,-557,386
  1735,-437,1738
  1749,-1800,1813
  1772,-405,1572
  1776,-675,371
  1779,-442,1789
  1780,-1548,337
  1786,-1538,337
  1847,-1591,415
  1889,-1729,1762
  1994,-1805,1792

  In total, there are 79 beacons.

  Assemble the full map of beacons. How many beacons are there?

  --- Part Two ---

  Sometimes, it's a good idea to appreciate just how big the ocean is. Using
  the Manhattan distance, how far apart do the scanners get?

  In the above example, scanners 2 (1105,-1205,1229) and 3 (-92,-2380,-20) are
  the largest Manhattan distance apart. In total, they are
  1197 + 1175 + 1249 = 3621 units apart.

  What is the largest Manhattan distance between any two scanners?
  """
  @confidence_score 11

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.reduce([], fn line, report ->
      if String.starts_with?(line, "---") do
        [[] | report]
      else
        [scanner_report | rest_of_report] = report

        beacon =
          String.split(line, ",")
          |> Enum.map(&String.to_integer/1)

        [[beacon | scanner_report] | rest_of_report]
      end
    end)
    |> Enum.reverse()
  end

  def solve1(scanner_reports) do
    [base_scanner | other_reports] = Enum.map(scanner_reports, &prepare_report/1)

    {beacons, _, _, _} = normalize_to_base(Tuple.append(base_scanner, [[0, 0, 0]]), other_reports)

    length(beacons)
  end

  def solve2(scanner_reports) do
    [base_scanner | other_reports] = Enum.map(scanner_reports, &prepare_report/1)

    {_, _, _, scanners} =
      normalize_to_base(Tuple.append(base_scanner, [[0, 0, 0]]), other_reports)

    find_largest_manhattan_distance(scanners)
  end

  def prepare_report(report) do
    {distances, graph} = to_distances(report)

    {report, distances, graph}
  end

  defp to_distances(beacons, distances \\ MapSet.new(), graph \\ %{})

  defp to_distances([], distances, graph), do: {distances, graph}

  defp to_distances([base_beacon | rest], distances, graph) do
    distances_from_beacon = distances_from_beacon(base_beacon, rest)

    updated_distances =
      Enum.reduce(distances_from_beacon, distances, fn {distance, _, _}, distances ->
        MapSet.put(distances, distance)
      end)

    updated_graph =
      Enum.reduce(distances_from_beacon, graph, fn {_, distance_vector, beacon}, graph ->
        update_graph(graph, base_beacon, distance_vector)
        |> update_graph(beacon, distance_vector)
      end)

    to_distances(rest, updated_distances, updated_graph)
  end

  defp distances_from_beacon(base_beacon, other_beacons) do
    Enum.map(other_beacons, fn beacon ->
      distance_vector = distance_vector(base_beacon, beacon)

      distance = Enum.map(distance_vector, &(&1 * &1)) |> Enum.sum()

      {distance, distance_vector, beacon}
    end)
  end

  defp distance_vector(b1, b2) do
    Enum.zip(b1, b2)
    |> Enum.map(fn {x1, x2} -> abs(x1 - x2) end)
    |> Enum.sort()
  end

  defp update_graph(graph, b1, d) do
    Map.update(graph, b1, MapSet.new([d]), fn ds -> MapSet.put(ds, d) end)
  end

  defp find_largest_overlap({_, base_distances, _, _}, other_scanners) do
    largest_overlap =
      Enum.max_by(other_scanners, fn {_, distances, _} ->
        MapSet.intersection(base_distances, distances)
        |> MapSet.size()
      end)

    {largest_overlap, List.delete(other_scanners, largest_overlap)}
  end

  defp find_best_matching_beacons({_, _, beacons1, _}, {_, _, beacons2}) do
    Map.to_list(beacons1)
    |> Enum.flat_map(fn {b1, dv1} ->
      best_match =
        Map.to_list(beacons2)
        |> Enum.map(fn {b2, dv2} ->
          matching_distances =
            MapSet.intersection(dv2, dv1)
            |> MapSet.size()

          {b2, matching_distances}
        end)
        |> Enum.max_by(fn {_, confidence_score} -> confidence_score end)

      case best_match do
        {b2, confidence_score} when confidence_score >= @confidence_score -> [{b1, b2}]
        _ -> []
      end
    end)
  end

  defp verify_mapping?([{base_b1, tr_b1} | rest]) do
    Enum.all?(rest, fn {base_b2, tr_b2} ->
      distance_vector(base_b1, base_b2) == distance_vector(tr_b1, tr_b2)
    end)
  end

  defp find_transform_fn([{base_b1, tr_b1} | rest]) do
    {base_b2, tr_b2} =
      Enum.find(rest, nil, fn {base_b2, _} ->
        dv = distance_vector(base_b1, base_b2)
        dv_size = length(dv)
        dv_size == length(Enum.uniq(dv))
      end)

    tr_distances =
      Enum.zip(tr_b1, tr_b2)
      |> Enum.map(fn {x1, x2} -> abs(x1 - x2) end)

    order_transform =
      Enum.zip(base_b1, base_b2)
      |> Enum.map(fn {x1, x2} -> abs(x1 - x2) end)
      |> Enum.map(fn distance ->
        Enum.find_index(tr_distances, fn tr_d -> tr_d == distance end)
      end)

    tr_directed_distances =
      Enum.zip(tr_b1, tr_b2)
      |> Enum.map(fn {x1, x2} -> x1 - x2 end)

    direction_transform =
      Enum.zip(base_b1, base_b2)
      |> Enum.map(fn {x1, x2} -> x1 - x2 end)
      |> Enum.zip(order_transform)
      |> Enum.map(fn {dir_distance, order_tr} ->
        if Enum.at(tr_directed_distances, order_tr) * dir_distance > 0, do: 1, else: -1
      end)

    offset_transform =
      Enum.map(order_transform, fn order_tr -> Enum.at(tr_b1, order_tr) end)
      |> Enum.zip_with(direction_transform, fn tr_x, dir_tr -> dir_tr * tr_x end)
      |> Enum.zip_with(base_b1, fn tr_x, base_x -> base_x - tr_x end)

    Enum.zip([order_transform, direction_transform, offset_transform])
  end

  defp transform(beacon, transform_fn) do
    Enum.map(transform_fn, fn {order_tr, dir_tr, offset_tr} ->
      Enum.at(beacon, order_tr) * dir_tr + offset_tr
    end)
  end

  defp merge_into_base(
         {base_report, base_distances, base_graph, other_scanners},
         {other_report, other_distances, other_graph},
         transform_fn
       ) do
    normalized_other_report = Enum.map(other_report, &transform(&1, transform_fn))

    updated_report = Enum.uniq(base_report ++ normalized_other_report)
    updated_distances = MapSet.union(base_distances, other_distances)

    updated_graph =
      Map.to_list(other_graph)
      |> Enum.reduce(base_graph, fn {other_b, dvs}, graph ->
        normalized_b = transform(other_b, transform_fn)

        Map.update(graph, normalized_b, dvs, fn existing_dvs ->
          MapSet.union(existing_dvs, dvs)
        end)
      end)

    other_scanner = Enum.map(transform_fn, &elem(&1, 2))

    updated_scanners = [other_scanner | other_scanners]

    {updated_report, updated_distances, updated_graph, updated_scanners}
  end

  defp normalize_to_base(base_scanner, []) do
    base_scanner
  end

  defp normalize_to_base(base_scanner, other_scanners) do
    {most_overlapping_scanner, other_scanners} =
      find_largest_overlap(base_scanner, other_scanners)

    mapping = find_best_matching_beacons(base_scanner, most_overlapping_scanner)

    if !verify_mapping?(mapping) do
      IO.inspect(base_scanner)
      IO.inspect(most_overlapping_scanner)
      raise "Something went wrong..."
    end

    transform_fn = find_transform_fn(mapping)
    base_scanner = merge_into_base(base_scanner, most_overlapping_scanner, transform_fn)

    normalize_to_base(base_scanner, other_scanners)
  end

  defp find_largest_manhattan_distance(scanners, max \\ 0)

  defp find_largest_manhattan_distance([_], max), do: max

  defp find_largest_manhattan_distance([head_scanner | scanners], max) do
    max_distance =
      Enum.map(scanners, fn scanner ->
        Enum.zip_reduce(head_scanner, scanner, 0, fn x, y, sum -> abs(x - y) + sum end)
      end)
      |> Enum.max()

    find_largest_manhattan_distance(scanners, max(max, max_distance))
  end
end
