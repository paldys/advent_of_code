use std::{collections::HashSet, vec};

use super::Result;

#[derive(Clone, Debug)]
enum Direction {
    Up,
    Right,
    Down,
    Left,
}

pub fn solve_first(input: String) -> Result {
    count_tail_visited(input, 2)
}

pub fn solve_second(input: String) -> Result {
    count_tail_visited(input, 10)
}

fn count_tail_visited(input: String, length: usize) -> Result {
    let mut rope = vec![(0, 0); length];
    let mut tail_visited: HashSet<(i32, i32)> = HashSet::new();
    tail_visited.insert(rope[length - 1]);
    for direction in parse_input(input) {
        rope[0] = next_head_pos(rope[0], direction);
        for i in 1..length {
            rope[i] = next_pos(rope[i - 1], rope[i]);
        }
        tail_visited.insert(rope[length - 1]);
    }
    Result::Number(tail_visited.len() as u32)
}

fn next_head_pos(pos: (i32, i32), direction: Direction) -> (i32, i32) {
    match direction {
        Direction::Up => (pos.0, pos.1 + 1),
        Direction::Right => (pos.0 + 1, pos.1),
        Direction::Down => (pos.0, pos.1 - 1),
        Direction::Left => (pos.0 - 1, pos.1),
    }
}

fn next_pos(leader: (i32, i32), follower: (i32, i32)) -> (i32, i32) {
    let new_tail_0 = if (leader.0 - follower.0).abs() > 1 {
        follower.0 + (leader.0 - follower.0).signum()
    } else if (leader.1 - follower.1).abs() > 1 && leader.0 != follower.0 {
        leader.0
    } else {
        follower.0
    };
    let new_tail_1 = if (leader.1 - follower.1).abs() > 1 {
        follower.1 + (leader.1 - follower.1).signum()
    } else if (leader.0 - follower.0).abs() > 1 && leader.1 != follower.1 {
        leader.1
    } else {
        follower.1
    };
    (new_tail_0, new_tail_1)
}

fn parse_input(input: String) -> Vec<Direction> {
    input
        .trim_end()
        .split('\n')
        .flat_map(|line| {
            let split_line: Vec<&str> = line.split(' ').collect();
            let move_type = match split_line[0] {
                "U" => Direction::Up,
                "R" => Direction::Right,
                "D" => Direction::Down,
                "L" => Direction::Left,
                _ => panic!("Unknown direction"),
            };
            let move_count: usize = split_line[1].parse().unwrap();
            vec![move_type; move_count]
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT_1: &str = "R 4\n\
    U 4\n\
    L 3\n\
    D 1\n\
    R 4\n\
    D 1\n\
    L 5\n\
    R 2\n";

    static RAW_INPUT_2: &str = "R 5\n\
    U 8\n\
    L 8\n\
    D 3\n\
    R 17\n\
    D 10\n\
    L 25\n\
    U 20\n";

    #[test]
    fn solves_first() {
        assert_eq_number(13, solve_first(String::from(RAW_INPUT_1)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(1, solve_second(String::from(RAW_INPUT_1)));
        assert_eq_number(36, solve_second(String::from(RAW_INPUT_2)));
    }
}
