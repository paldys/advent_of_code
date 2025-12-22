use super::Result;
use std::collections::{HashMap, HashSet};

struct Machine {
    diagram: u64,
    wiring: Vec<u64>,
}

pub fn solve_first(input: String) -> Result {
    let machines = parse_input(&input);
    let least_presses = machines.iter().map(configure_machine).sum();
    Result::Number(least_presses)
}

fn configure_machine(machine: &Machine) -> u64 {
    let mut least_presses = HashMap::new();
    least_presses.insert(0_u64, 0_u64);
    let wiring = machine.wiring.iter().copied().collect();
    find_configuration(0, 0, wiring, &mut least_presses);
    least_presses.get(&machine.diagram).copied().unwrap()
}

fn find_configuration(
    curr: u64,
    presses: u64,
    wiring: HashSet<u64>,
    least_presses: &mut HashMap<u64, u64>,
) {
    let mut try_wiring = Vec::new();
    let new_presses = presses + 1;
    for &w in wiring.iter() {
        let new_curr = curr ^ w;
        least_presses
            .entry(new_curr)
            .and_modify(|cached_presses| {
                if *cached_presses > new_presses {
                    *cached_presses = new_presses;
                    try_wiring.push(w);
                }
            })
            .or_insert_with(|| {
                try_wiring.push(w);
                new_presses
            });
    }
    for &w in try_wiring.iter() {
        let new_curr = curr ^ w;
        let mut new_wiring: HashSet<u64> = wiring.iter().copied().collect();
        new_wiring.remove(&w);
        find_configuration(new_curr, new_presses, new_wiring, least_presses);
    }
}

fn parse_input(input: &str) -> Vec<Machine> {
    input.lines().map(parse_machine).collect()
}

fn parse_machine(input: &str) -> Machine {
    let mut parts = input.split_whitespace();
    let diagram = parse_diagram(parts.next().unwrap());
    let mut wiring = Vec::new();

    for part in parts {
        if part.starts_with('{') {
            break; // ignore for now
        }
        if part.starts_with('(') {
            wiring.push(parse_wiring(part));
        }
    }

    Machine { diagram, wiring }
}

fn parse_diagram(s: &str) -> u64 {
    s.trim_matches(['[', ']'])
        .bytes()
        .rev()
        .fold(0u64, |acc, b| (acc << 1) | if b == b'#' { 1 } else { 0 })
}

fn parse_wiring(s: &str) -> u64 {
    let mut value = 0u64;

    let inner = s.trim_matches(['(', ')']);
    if inner.is_empty() {
        return value;
    }

    for idx in inner.split(',').map(|x| x.parse::<u64>().unwrap()) {
        value |= 1 << idx;
    }

    value
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}\n\
        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}\n\
        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}";

    #[test]
    fn solves_first() {
        assert_eq_number(7, solve_first(String::from(RAW_INPUT)));
    }
}
