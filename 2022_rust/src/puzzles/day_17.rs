use std::collections::HashMap;

use super::Result;

const CHAMBER_WIDTH: usize = 7;

enum Direction {
    Left,
    Right,
}

struct Shape {
    w: usize,
    h: usize,
    bitmap: Vec<Vec<bool>>,
}

pub fn solve_first(input: String) -> Result {
    let height = simulate_rock_falling(input, 2022);

    Result::Number(height as u32)
}

pub fn solve_second(input: String) -> Result {
    let height = simulate_rock_falling(input, 1000000000000);

    Result::String(height.to_string())
}

fn simulate_rock_falling(input: String, rock_count: usize) -> usize {
    let jet_pattern = parse_input(input);
    let jet_pattern_count = jet_pattern.len();
    let shapes = prepare_shapes();
    let shapes_count = shapes.len();

    let mut chamber = vec![vec![true; CHAMBER_WIDTH]];
    let mut normalized_h = 0;
    let mut repeat: HashMap<(usize, usize, u32), (usize, usize)> = HashMap::new();

    let mut jet_push_n = 0;

    let mut shape_n = 0;
    while shape_n < rock_count {
        let current_shape = &shapes[shape_n % shapes_count];

        let mut shape_position = (2, chamber.len() + 3);
        loop {
            shape_position = try_jet_push(
                &chamber,
                current_shape,
                shape_position,
                &jet_pattern[jet_push_n % jet_pattern_count],
            );
            jet_push_n += 1;
            let position_after_fall = (shape_position.0, shape_position.1 - 1);
            if is_overlapping(&chamber, current_shape, position_after_fall) {
                break;
            }
            shape_position = position_after_fall;
        }
        add_rock(&mut chamber, current_shape, shape_position);
        if let Some(full_line_at) = find_full_line(&chamber, shape_position.1) {
            chamber.drain(0..full_line_at);
            normalized_h += full_line_at;

            let chamber_hash = chamber_to_u32(&chamber);
            let repeat_key = (
                shape_n % shapes_count,
                jet_push_n % jet_pattern_count,
                chamber_hash,
            );
            if let Some((repeat_n, repeat_h)) = repeat.get(&repeat_key).copied() {
                repeat.clear();

                let repeated_after = shape_n - repeat_n;
                let times = (rock_count - shape_n) / repeated_after;
                normalized_h += times * (normalized_h - repeat_h);
                shape_n += times * repeated_after;
            } else {
                repeat.insert(repeat_key, (shape_n, normalized_h));
            }
        }
        shape_n += 1;
    }

    normalized_h + chamber.len() - 1
}

fn chamber_to_u32(chamber: &Vec<Vec<bool>>) -> u32 {
    let mut n = 0;
    for r in chamber {
        for c in r {
            n <<= 1;
            if *c {
                n |= 1;
            }
        }
    }
    n
}

fn find_full_line(chamber: &Vec<Vec<bool>>, last_y: usize) -> Option<usize> {
    (last_y..(chamber.len())).find(|&y| chamber[y].iter().all(|b| *b))
}

fn add_rock(chamber: &mut Vec<Vec<bool>>, shape: &Shape, (new_x, new_y): (usize, usize)) {
    for y in 0..shape.h {
        if y + new_y >= chamber.len() {
            chamber.push(vec![false; CHAMBER_WIDTH]);
        }

        for x in 0..shape.w {
            chamber[y + new_y][x + new_x] = chamber[y + new_y][x + new_x] || shape.bitmap[y][x];
        }
    }
}

fn try_jet_push(
    chamber: &Vec<Vec<bool>>,
    shape: &Shape,
    (cur_x, cur_y): (usize, usize),
    jet_push: &Direction,
) -> (usize, usize) {
    let next_x = match jet_push {
        Direction::Left => cur_x.checked_sub(1),
        Direction::Right => {
            if cur_x + shape.w < CHAMBER_WIDTH {
                Some(cur_x + 1)
            } else {
                None
            }
        }
    };

    if let Some(next_x) = next_x {
        if is_overlapping(chamber, shape, (next_x, cur_y)) {
            (cur_x, cur_y)
        } else {
            (next_x, cur_y)
        }
    } else {
        (cur_x, cur_y)
    }
}

fn is_overlapping(chamber: &Vec<Vec<bool>>, shape: &Shape, (new_x, new_y): (usize, usize)) -> bool {
    for y in 0..shape.h {
        if y + new_y < chamber.len() {
            for x in 0..shape.w {
                if chamber[y + new_y][x + new_x] && shape.bitmap[y][x] {
                    return true;
                }
            }
        } else {
            return false;
        }
    }
    false
}

fn prepare_shapes() -> Vec<Shape> {
    let shape_1 = Shape {
        w: 4,
        h: 1,
        bitmap: vec![vec![true; 4]],
    };
    let shape_2 = Shape {
        w: 3,
        h: 3,
        bitmap: vec![
            vec![false, true, false],
            vec![true, true, true],
            vec![false, true, false],
        ],
    };
    let shape_3 = Shape {
        w: 3,
        h: 3,
        bitmap: vec![
            vec![true, true, true],
            vec![false, false, true],
            vec![false, false, true],
        ],
    };
    let shape_4 = Shape {
        w: 1,
        h: 4,
        bitmap: vec![vec![true]; 4],
    };
    let shape_5 = Shape {
        w: 2,
        h: 2,
        bitmap: vec![vec![true; 2]; 2],
    };

    vec![shape_1, shape_2, shape_3, shape_4, shape_5]
}

fn parse_input(input: String) -> Vec<Direction> {
    input
        .trim_end()
        .as_bytes()
        .iter()
        .map(|c| match c {
            b'<' => Direction::Left,
            b'>' => Direction::Right,
            _ => panic!("Unexpected character"),
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::input_utils::get_input;
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>\n";

    #[test]
    fn solves_first() {
        assert_eq_number(3068, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_for_100000() {
        assert_eq!(155657, simulate_rock_falling(get_input(17), 100000));
    }
}
