use super::Result;
use std::collections::HashMap;

pub fn solve_first(input: String) -> Result {
    let device_map = parse_input(&input);
    let mut device_paths = HashMap::new();
    device_paths.insert("out", 1);
    Result::Number(find_paths("you", &device_map, &mut device_paths))
}

fn find_paths<'a>(
    device: &'a str,
    device_map: &HashMap<&'a str, Vec<&'a str>>,
    device_paths: &mut HashMap<&'a str, u64>,
) -> u64 {
    if let Some(&cached) = device_paths.get(device) {
        return cached;
    }

    let paths = device_map
        .get(device)
        .map(|next_devices| {
            next_devices
                .iter()
                .map(|&next| find_paths(next, device_map, device_paths))
                .sum()
        })
        .unwrap_or(0);

    device_paths.insert(device, paths);
    paths
}

fn parse_input(input: &str) -> HashMap<&str, Vec<&str>> {
    input
        .lines()
        .map(|l| {
            let mut devices: Vec<&str> = l.split_whitespace().collect();
            let device = devices.remove(0).trim_matches(':');
            (device, devices)
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        aaa: you hhh\n\
        you: bbb ccc\n\
        bbb: ddd eee\n\
        ccc: ddd eee fff\n\
        ddd: ggg\n\
        eee: out\n\
        fff: out\n\
        ggg: out\n\
        hhh: ccc fff iii\n\
        iii: out";

    #[test]
    fn solves_first() {
        assert_eq_number(5, solve_first(String::from(RAW_INPUT)));
    }
}
