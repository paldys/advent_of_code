use std::cmp::Ordering;

use super::Result;

#[derive(Debug)]
enum Packet {
    Array(Vec<Packet>),
    Number(u32),
}

pub fn solve_first(input: String) -> Result {
    let packet_pairs = parse_input(input);
    let in_right_order = packet_pairs
        .iter()
        .enumerate()
        .map(|(i, (p1, p2))| {
            if check_order(p1, p2) != Ordering::Greater {
                (i + 1) as u32
            } else {
                0
            }
        })
        .sum();
    Result::Number(in_right_order)
}

fn check_order(p1: &Packet, p2: &Packet) -> Ordering {
    match (p1, p2) {
        (Packet::Number(n1), Packet::Number(n2)) => n1.cmp(n2),
        (Packet::Number(n), arr_packet) => {
            check_order(&Packet::Array(vec![Packet::Number(*n)]), arr_packet)
        }
        (arr_packet, Packet::Number(n)) => {
            check_order(arr_packet, &Packet::Array(vec![Packet::Number(*n)]))
        }
        (Packet::Array(a1), Packet::Array(a2)) => a1.iter().cmp_by(a2, check_order),
    }
}

fn parse_input(input: String) -> Vec<(Packet, Packet)> {
    input
        .split('\n')
        .array_chunks::<3>()
        .map(|[pair_left, pair_right, _empty]| (parse_line(pair_left).0, parse_line(pair_right).0))
        .collect()
}

fn parse_line(line: &str) -> (Packet, usize) {
    if line.starts_with('[') {
        let mut arr = Vec::new();
        let mut cur_pos = 1;
        while line.chars().nth(cur_pos).unwrap() != ']' {
            let (packet, next_pos) = parse_line(&line[cur_pos..]);
            cur_pos += next_pos;
            if (line.chars().nth(cur_pos)).unwrap() == ',' {
                cur_pos += 1;
            }
            arr.push(packet);
        }
        (Packet::Array(arr), cur_pos + 1)
    } else {
        let rest_start = line
            .find(|c: char| !c.is_numeric())
            .unwrap_or(line.len() - 1);
        (
            Packet::Number(line[0..rest_start].parse().unwrap()),
            rest_start,
        )
    }
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "[1,1,3,1,1]\n\
    [1,1,5,1,1]\n\
    \n\
    [[1],[2,3,4]]\n\
    [[1],4]\n\
    \n\
    [9]\n\
    [[8,7,6]]\n\
    \n\
    [[4,4],4,4]\n\
    [[4,4],4,4,4]\n\
    \n\
    [7,7,7,7]\n\
    [7,7,7]\n\
    \n\
    []\n\
    [3]\n\
    \n\
    [[[]]]\n\
    [[]]\n\
    \n\
    [1,[2,[3,[4,[5,6,7]]]],8,9]\n\
    [1,[2,[3,[4,[5,6,0]]]],8,9]\n";

    #[test]
    fn solves_first() {
        assert_eq_number(13, solve_first(String::from(RAW_INPUT)));
    }
}
