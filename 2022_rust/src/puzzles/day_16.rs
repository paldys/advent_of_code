use std::cmp::{max, min};
use std::collections::{HashMap, HashSet};

use regex::Regex;

use super::Result;
use crate::utils::unwrap_match_to_i64;

#[derive(Debug, Clone)]
struct Valve {
    flow_rate: u32,
    tunnel_to: HashMap<String, i32>,
}

pub fn solve_first(input: String) -> Result {
    let mut valve_system = parse_input(input);
    optimize_valve_system(&mut valve_system);
    floyd_warshall_the_system(&mut valve_system);

    let pressure = find_most_pressure(&valve_system, "AA", 30, &HashSet::new(), 0);

    Result::Number(pressure)
}

fn find_most_pressure(
    valve_system: &HashMap<String, Valve>,
    current_valve_name: &str,
    minutes_left: u32,
    released: &HashSet<String>,
    released_pressure: u32,
) -> u32 {
    let mut next_released = released.clone();
    next_released.insert(current_valve_name.to_string());
    let mut most_pressure = released_pressure * minutes_left;
    let current_valve = valve_system.get(current_valve_name).unwrap();
    for (next_valve_name, distance) in &current_valve.tunnel_to {
        if next_released.contains(next_valve_name) {
            continue;
        }
        let distance = (*distance) as u32;
        if distance + 1 < minutes_left {
            let next_released_pressure =
                released_pressure + valve_system.get(next_valve_name).unwrap().flow_rate;
            let new_pressure = find_most_pressure(
                valve_system,
                next_valve_name,
                minutes_left - 1 - distance,
                &next_released,
                next_released_pressure,
            );
            most_pressure = max(
                most_pressure,
                released_pressure * (distance + 1) + new_pressure,
            );
        }
    }
    most_pressure
}

fn floyd_warshall_the_system(valve_system: &mut HashMap<String, Valve>) {
    for (valve_name, valve) in valve_system.iter_mut() {
        valve.tunnel_to.insert(valve_name.clone(), 0);
    }
    let valve_names: Vec<String> = valve_system.keys().cloned().collect();
    for k in &valve_names {
        for i in &valve_names {
            for j in &valve_names {
                let k_to_j = valve_system
                    .get(k)
                    .and_then(|v| v.tunnel_to.get(j))
                    .copied();
                let valve = valve_system.get_mut(i).unwrap();
                let i_to_j = valve.tunnel_to.get(j);
                let i_to_k = valve.tunnel_to.get(k);
                let new_i_to_j = i_to_k.and_then(|x| k_to_j.map(|y| x + y));
                if let Some(n) =
                    new_i_to_j.and_then(|n| i_to_j.map_or(Some(n), |o| Some(min(n, *o))))
                {
                    valve.tunnel_to.insert(j.to_string(), n);
                }
            }
        }
    }
}

fn optimize_valve_system(valve_system: &mut HashMap<String, Valve>) {
    'outer: loop {
        let maybe_zero_valve = valve_system
            .iter_mut()
            .find(|(k, v)| *k != "AA" && v.flow_rate == 0)
            .map(|(k, _)| k.clone());
        match maybe_zero_valve {
            Some(zero_valve_name) => {
                let zero_valve = valve_system.remove(&zero_valve_name).unwrap();
                for from_valve_name in zero_valve.tunnel_to.keys() {
                    let from_valve = valve_system.get_mut(from_valve_name).unwrap();
                    let from_zero_distance = from_valve.tunnel_to.remove(&zero_valve_name).unwrap();
                    for to_valve_name in zero_valve.tunnel_to.keys() {
                        if to_valve_name != from_valve_name {
                            let &to_zero_distance =
                                zero_valve.tunnel_to.get(to_valve_name).unwrap();
                            let distance = from_zero_distance + to_zero_distance;
                            let old_distance = from_valve.tunnel_to.get(to_valve_name);
                            if old_distance.is_none() || *old_distance.unwrap() > distance {
                                from_valve.tunnel_to.insert(
                                    to_valve_name.clone(),
                                    from_zero_distance + to_zero_distance,
                                );
                            }
                        }
                    }
                }
            }
            None => {
                break 'outer;
            }
        };
    }
}

fn parse_input(input: String) -> HashMap<String, Valve> {
    let line_re: Regex =
        Regex::new(r"^Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z, ]+)$")
            .unwrap();

    let mut valve_system = HashMap::new();
    for line in input.trim_end().split('\n') {
        let captures = line_re.captures(line).unwrap();
        let valve_name = captures.get(1).unwrap().as_str();
        let flow_rate = unwrap_match_to_i64(captures.get(2)) as u32;
        let mut tunnel_to = HashMap::new();
        captures
            .get(3)
            .unwrap()
            .as_str()
            .split(", ")
            .map(String::from)
            .for_each(|tunnel| {
                tunnel_to.insert(tunnel, 1);
            });
        valve_system.insert(
            String::from(valve_name),
            Valve {
                flow_rate,
                tunnel_to,
            },
        );
    }
    valve_system
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB\n\
    Valve BB has flow rate=13; tunnels lead to valves CC, AA\n\
    Valve CC has flow rate=2; tunnels lead to valves DD, BB\n\
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE\n\
    Valve EE has flow rate=3; tunnels lead to valves FF, DD\n\
    Valve FF has flow rate=0; tunnels lead to valves EE, GG\n\
    Valve GG has flow rate=0; tunnels lead to valves FF, HH\n\
    Valve HH has flow rate=22; tunnel leads to valve GG\n\
    Valve II has flow rate=0; tunnels lead to valves AA, JJ\n\
    Valve JJ has flow rate=21; tunnel leads to valve II\n";

    #[test]
    fn solves_first() {
        assert_eq_number(1651, solve_first(String::from(RAW_INPUT)));
    }
}
