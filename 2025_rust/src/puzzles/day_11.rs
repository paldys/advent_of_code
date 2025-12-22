use super::Result;
use std::collections::HashMap;

pub fn solve_first(input: String) -> Result {
    let device_map = parse_input(&input);
    let mut device_paths = HashMap::new();
    device_paths.insert("out", (0, 0, 0, 1));
    Result::Number(find_paths("you", &device_map, &mut device_paths).3)
}

pub fn solve_second(input: String) -> Result {
    let device_map = parse_input(&input);
    let mut device_paths = HashMap::new();
    device_paths.insert("out", (0, 0, 0, 1));
    Result::Number(find_paths("svr", &device_map, &mut device_paths).0)
}

fn find_paths<'a>(
    device: &'a str,
    device_map: &HashMap<&'a str, Vec<&'a str>>,
    device_paths: &mut HashMap<&'a str, (u64, u64, u64, u64)>,
) -> (u64, u64, u64, u64) {
    if let Some(&cached) = device_paths.get(device) {
        return cached;
    }

    let paths = device_map
        .get(device)
        .map(|next_devices| {
            next_devices
                .iter()
                .map(|&next| {
                    let p = find_paths(next, device_map, device_paths);
                    if device == "dac" {
                        (p.0 + p.1, p.1, p.3, p.3)
                    } else if device == "fft" {
                        (p.0 + p.2, p.3, p.2, p.3)
                    } else {
                        p
                    }
                })
                .fold((0, 0, 0, 0), |acc, x| {
                    (acc.0 + x.0, acc.1 + x.1, acc.2 + x.2, acc.3 + x.3)
                })
        })
        .unwrap_or((0, 0, 0, 0));

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

    static RAW_INPUT_2: &str = "\
        svr: aaa bbb\n\
        aaa: fft\n\
        fft: ccc\n\
        bbb: tty\n\
        tty: ccc\n\
        ccc: ddd eee\n\
        ddd: hub\n\
        hub: fff\n\
        eee: dac\n\
        dac: fff\n\
        fff: ggg hhh\n\
        ggg: out\n\
        hhh: out";

    #[test]
    fn solves_first() {
        assert_eq_number(5, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(2, solve_second(String::from(RAW_INPUT_2)));
    }
}
