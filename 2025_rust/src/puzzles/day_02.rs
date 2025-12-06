use super::Result;
use std::collections::BTreeMap;
use std::collections::HashSet;

pub fn solve_first(input: String) -> Result {
    let mut sum = 0;
    let ranges = parse_ranges(input);
    if let Some((_, max)) = ranges.last_key_value() {
        let invalid_ids = generate_invalid_ids(*max);
        for id in invalid_ids {
            if let Some((lo, up)) = ranges.range(..=id).next_back()
                && *lo <= id
                && id <= *up
            {
                sum += id;
            }
        }
    }
    Result::Number(sum)
}

pub fn solve_second(input: String) -> Result {
    let mut sum = 0;
    let ranges = parse_ranges(input);
    if let Some((_, max)) = ranges.last_key_value() {
        let invalid_ids = generate_invalid_ids_part2(*max);
        for id in invalid_ids {
            if let Some((lo, up)) = ranges.range(..=id).next_back()
                && *lo <= id
                && id <= *up
            {
                sum += id;
            }
        }
    }
    Result::Number(sum)
}

fn generate_invalid_ids(max: u64) -> HashSet<u64> {
    let mut invalid_ids = HashSet::new();

    let mut i = 1_u64;
    let mut m = 10_u64;
    let mut n = i * m + i;

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

    let mut i = 1_u64;
    let mut m = 10_u64;
    let mut n = i * m + i;

    loop {
        if n <= max {
            invalid_ids.insert(n);
            n = n * m + i;
        } else {
            if i + 1 < m {
                i += 1;
            } else {
                i += 1;
                m *= 10;
            }
            n = i * m + i;

            if n > max {
                break;
            }
        }
    }

    invalid_ids
}

fn parse_ranges(input: String) -> BTreeMap<u64, u64> {
    input
        .trim()
        .split(',')
        .filter_map(|raw| parse_range(raw).map(|(_, lo, hi)| (lo, hi)))
        .collect()
}

fn parse_range(s: &str) -> Option<(u32, u64, u64)> {
    let mut range: Vec<_> = s.split('-').collect();
    let upper = range.pop();
    let lower = range.pop();
    match (lower, upper) {
        (Some(l), Some(u)) => Some((
            l.len().try_into().unwrap(),
            l.parse().ok()?,
            u.parse().ok()?,
        )),
        _ => None,
    }
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
