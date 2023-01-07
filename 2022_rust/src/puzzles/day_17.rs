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
    let chamber = simulate_rock_falling(input, 2022);

    Result::Number((chamber.len() - 1) as u32)
}

fn simulate_rock_falling(input: String, rock_count: usize) -> Vec<Vec<bool>> {
    let jet_pattern = parse_input(input);
    let jet_pattern_count = jet_pattern.len();
    let shapes = prepare_shapes();
    let shapes_count = shapes.len();

    let mut chamber = vec![vec![true; CHAMBER_WIDTH]];

    let mut jet_push_n = 0;

    for shape_n in 0..rock_count {
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
    }

    chamber
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
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>\n";

    #[test]
    fn solves_first() {
        assert_eq_number(3068, solve_first(String::from(RAW_INPUT)));
    }
}
