use super::Result;
use std::collections::BTreeMap;
use std::ops::Bound::Included;

pub fn solve_first(input: String) -> Result {
    let (fresh, available) = parse_input(&input);
    let fresh_available = available
        .into_iter()
        .filter(|&a| {
            fresh
                .range(..=a)
                .next_back()
                .map(|(_, top)| a <= *top)
                .unwrap_or(false)
        })
        .count();
    Result::Number(fresh_available as u64)
}

fn parse_input(input: &str) -> (BTreeMap<u64, u64>, Vec<u64>) {
    let mut fresh = BTreeMap::new();
    let mut available = Vec::new();
    for line in input.lines() {
        if line.trim().is_empty() {
            continue;
        }

        if let Some((left, right)) = line.split_once('-') {
            let start = left.parse().ok().unwrap();
            let end = right.parse().ok().unwrap();
            add_range(&mut fresh, start, end);
        } else {
            let i = line.parse().ok().unwrap();
            available.push(i);
        }
    }
    (fresh, available)
}

fn add_range(fresh: &mut BTreeMap<u64, u64>, start: u64, end: u64) {
    let mut new_start = start;
    let mut new_end = end;
    let ranges: Vec<(u64, u64)> = fresh
        .range((Included(start), Included(end)))
        .map(|(k, v)| (*k, *v))
        .collect();

    for (s, e) in ranges {
        if new_start > s {
            new_start = s;
        }
        if new_end < e {
            new_end = e;
        }
        fresh.remove(&s);
    }
    fresh.insert(new_start, new_end);
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        3-5\n\
        10-14\n\
        16-20\n\
        12-18\n\
        \n\
        1\n\
        5\n\
        8\n\
        11\n\
        17\n\
        32";

    #[test]
    fn solves_first() {
        assert_eq_number(3, solve_first(String::from(RAW_INPUT)));
    }
}
