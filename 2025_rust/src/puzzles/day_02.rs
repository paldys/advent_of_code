use super::Result;
use std::collections::{BTreeMap, HashSet};

pub fn solve_first(input: String) -> Result {
    solve_with(input, generate_invalid_ids)
}

pub fn solve_second(input: String) -> Result {
    solve_with(input, generate_invalid_ids_part2)
}

fn solve_with(input: String, generator: impl Fn(u64) -> HashSet<u64>) -> Result {
    let ranges = parse_ranges(&input);

    let Some((_, max)) = ranges.last_key_value() else {
        return Result::Number(0);
    };

    let invalid_ids = generator(*max);

    let sum: u64 = invalid_ids
        .into_iter()
        .filter(|&id| {
            ranges
                .range(..=id)
                .next_back()
                .map(|(_, up)| id <= *up)
                .unwrap_or(false)
        })
        .sum();

    Result::Number(sum)
}

fn init_invalid_id_state() -> (u64, u64, u64) {
    let i = 1;
    let m = 10;
    let n = i * m + i;
    (i, m, n)
}

fn generate_invalid_ids(max: u64) -> HashSet<u64> {
    let mut invalid_ids = HashSet::new();
    let (mut i, mut m, mut n) = init_invalid_id_state();

    while n <= max {
        invalid_ids.insert(n);

        if i + 1 < m {
            i += 1;
        } else {
            i += 1;
            m *= 10;
        }
        n = i * m + i;
    }

    invalid_ids
}

fn generate_invalid_ids_part2(max: u64) -> HashSet<u64> {
    let mut invalid_ids = HashSet::new();
    let (mut i, mut m, mut n) = init_invalid_id_state();

    while n <= max {
        invalid_ids.insert(n);
        n = n * m + i;

        if n > max {
            if i + 1 < m {
                i += 1;
            } else {
                i += 1;
                m *= 10;
            }
            n = i * m + i;
        }
    }

    invalid_ids
}

fn parse_ranges(input: &str) -> BTreeMap<u64, u64> {
    input
        .trim()
        .split(',')
        .filter_map(|raw| parse_range(raw).map(|(_, lo, hi)| (lo, hi)))
        .collect()
}

fn parse_range(s: &str) -> Option<(u32, u64, u64)> {
    let (l, u) = s.split_once('-')?;
    Some((l.len() as u32, l.parse().ok()?, u.parse().ok()?))
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
    11-22,95-115,998-1012,1188511880-1188511890,\
    222220-222224,1698522-1698528,446443-446449,\
    38593856-38593862,565653-565659,\
    824824821-824824827,2121212118-2121212124";

    #[test]
    fn solves_first() {
        assert_eq_number(1227775554, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(4174379265, solve_second(String::from(RAW_INPUT)));
    }
}
