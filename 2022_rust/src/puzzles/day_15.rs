use std::cmp::max;
use std::collections::HashSet;

use regex::Regex;

use super::Result;
use crate::utils::unwrap_match_to_i64;

pub fn solve_first(input: String) -> Result {
    _solve_first(input, 2_000_000)
}

fn _solve_first(input: String, row: i64) -> Result {
    let sensors_and_beacons = parse_input(input);

    let mut no_beacon_intervals: Vec<(i64, i64)> = Vec::new();
    let mut beacon_or_sensor_in_row: HashSet<i64> = HashSet::new();

    for (s, b) in sensors_and_beacons {
        let bs_distance = (s.0 - b.0).abs() + (s.1 - b.1).abs();
        let row_distance = (s.1 - row).abs();
        let row_border_distance = bs_distance - row_distance;
        if row_border_distance < 0 {
            continue;
        }
        no_beacon_intervals.push(((s.0 - row_border_distance), (s.0 + row_border_distance)));
        if s.1 == row {
            beacon_or_sensor_in_row.insert(s.0);
        }
        if b.1 == row {
            beacon_or_sensor_in_row.insert(b.0);
        }
    }

    let no_beacon_intervals = optimize_intervals(no_beacon_intervals);
    let no_beacon_in_row = no_beacon_intervals
        .iter()
        .map(|i| i.1 - i.0 + 1)
        .sum::<i64>() as u32;

    Result::Number(no_beacon_in_row - beacon_or_sensor_in_row.len() as u32)
}

fn optimize_intervals(mut intervals: Vec<(i64, i64)>) -> Vec<(i64, i64)> {
    intervals.sort_by(|(a, _), (b, _)| a.cmp(b));
    let mut optimized_intervals: Vec<(i64, i64)> = Vec::new();
    for i2 in intervals {
        match optimized_intervals.pop() {
            None => optimized_intervals.push(i2),
            Some((s1, e1)) if i2.0 <= e1 => optimized_intervals.push((s1, max(e1, i2.1))),
            Some(i1) => {
                optimized_intervals.push(i1);
                optimized_intervals.push(i2);
            }
        };
    }
    optimized_intervals
}

fn parse_input(input: String) -> Vec<((i64, i64), (i64, i64))> {
    let line_re: Regex =
        Regex::new(r"^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$")
            .unwrap();
    input
        .trim_end()
        .split('\n')
        .map(|l| {
            let captures = line_re
                .captures(l)
                .expect("Input line is not of expected format");
            (
                (
                    unwrap_match_to_i64(captures.get(1)),
                    unwrap_match_to_i64(captures.get(2)),
                ),
                (
                    unwrap_match_to_i64(captures.get(3)),
                    unwrap_match_to_i64(captures.get(4)),
                ),
            )
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15\n\
    Sensor at x=9, y=16: closest beacon is at x=10, y=16\n\
    Sensor at x=13, y=2: closest beacon is at x=15, y=3\n\
    Sensor at x=12, y=14: closest beacon is at x=10, y=16\n\
    Sensor at x=10, y=20: closest beacon is at x=10, y=16\n\
    Sensor at x=14, y=17: closest beacon is at x=10, y=16\n\
    Sensor at x=8, y=7: closest beacon is at x=2, y=10\n\
    Sensor at x=2, y=0: closest beacon is at x=2, y=10\n\
    Sensor at x=0, y=11: closest beacon is at x=2, y=10\n\
    Sensor at x=20, y=14: closest beacon is at x=25, y=17\n\
    Sensor at x=17, y=20: closest beacon is at x=21, y=22\n\
    Sensor at x=16, y=7: closest beacon is at x=15, y=3\n\
    Sensor at x=14, y=3: closest beacon is at x=15, y=3\n\
    Sensor at x=20, y=1: closest beacon is at x=15, y=3\n";

    #[test]
    fn solves_first() {
        assert_eq_number(26, _solve_first(String::from(RAW_INPUT), 10));
    }
}
