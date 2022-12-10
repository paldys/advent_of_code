use std::collections::HashSet;

use super::Result;

#[derive(Clone)]
enum Direction {
    Up,
    Right,
    Down,
    Left,
}

pub fn solve_first(input: String) -> Result {
    let mut tail_visited: HashSet<(i32, i32)> = HashSet::new();
    let mut tail_pos = (0, 0);
    let mut head_pos = (0, 0);
    tail_visited.insert(tail_pos);
    for direction in parse_input(input) {
        head_pos = match direction {
            Direction::Up => (head_pos.0, head_pos.1 + 1),
            Direction::Right => (head_pos.0 + 1, head_pos.1),
            Direction::Down => (head_pos.0, head_pos.1 - 1),
            Direction::Left => (head_pos.0 - 1, head_pos.1),
        };
        let new_tail_0 = if (head_pos.0 - tail_pos.0).abs() > 1 {
            tail_pos.0 + (head_pos.0 - tail_pos.0).signum()
        } else if (head_pos.1 - tail_pos.1).abs() > 1 && head_pos.0 != tail_pos.0 {
            head_pos.0
        } else {
            tail_pos.0
        };
        let new_tail_1 = if (head_pos.1 - tail_pos.1).abs() > 1 {
            tail_pos.1 + (head_pos.1 - tail_pos.1).signum()
        } else if (head_pos.0 - tail_pos.0).abs() > 1 && head_pos.1 != tail_pos.1 {
            head_pos.1
        } else {
            tail_pos.1
        };
        tail_pos = (new_tail_0, new_tail_1);
        tail_visited.insert(tail_pos);
    }
    Result::Number(tail_visited.len() as u32)
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

    static RAW_INPUT: &str = "R 4\n\
    U 4\n\
    L 3\n\
    D 1\n\
    R 4\n\
    D 1\n\
    L 5\n\
    R 2\n";

    #[test]
    fn solves_first() {
        assert_eq_number(13, solve_first(String::from(RAW_INPUT)));
    }
}
