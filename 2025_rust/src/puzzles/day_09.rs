use super::Result;

#[derive(PartialEq, Clone, Copy)]
enum Direction {
    Up,
    Right,
    Down,
    Left,
}

pub fn solve_first(input: String) -> Result {
    let red_tiles = parse_input(&input);
    let mut max = 0;
    for left in 0..red_tiles.len() {
        for right in (left + 1)..red_tiles.len() {
            let (x1, y1) = red_tiles[left];
            let (x2, y2) = red_tiles[right];
            let area = (((x1 - x2).abs() + 1) * ((y1 - y2).abs() + 1)) as u64;
            if area > max {
                max = area;
            }
        }
    }
    Result::Number(max)
}

pub fn solve_second(input: String) -> Result {
    let red_tiles = parse_input(&input);
    let len = red_tiles.len();
    let border = compute_border(&red_tiles);

    let max = red_tiles
        .iter()
        .enumerate()
        .flat_map(|(left, &(x1, y1))| {
            red_tiles[left + 1..]
                .iter()
                .map(move |&(x2, y2)| (x1, y1, x2, y2))
        })
        .filter(|&(x1, y1, x2, y2)| {
            !border
                .iter()
                .zip(border.iter().cycle().skip(1))
                .take(len)
                .any(|(&a, &b)| line_intersects_rect((x1, y1), (x2, y2), a, b))
        })
        .map(|(x1, y1, x2, y2)| (((x1 - x2).abs() + 1) * ((y1 - y2).abs() + 1)) as u64)
        .max()
        .unwrap_or(0);

    Result::Number(max)
}

fn initial_direction(from: (i64, i64), to: (i64, i64)) -> Direction {
    let (x_n, y_n) = from;
    let (x_0, y_0) = to;
    if x_n == x_0 {
        if y_n < y_0 {
            Direction::Down
        } else {
            Direction::Up
        }
    } else if x_n < x_0 {
        Direction::Right
    } else {
        Direction::Left
    }
}

fn border_corner(x1: i64, y1: i64, x1_n: i64, y1_n: i64, direction: &mut Direction) -> (i64, i64) {
    match (x1 == x1_n, y1 < y1_n, *direction) {
        (true, true, Direction::Right) => {
            *direction = Direction::Down;
            (x1 + 1, y1 - 1)
        }
        (true, true, _) => {
            *direction = Direction::Down;
            (x1 + 1, y1 + 1)
        }
        (true, false, Direction::Right) => {
            *direction = Direction::Up;
            (x1 - 1, y1 - 1)
        }
        (true, false, _) => {
            *direction = Direction::Up;
            (x1 - 1, y1 + 1)
        }
        (false, _, Direction::Down) if x1 < x1_n => {
            *direction = Direction::Right;
            (x1 + 1, y1 - 1)
        }
        (false, _, _) if x1 < x1_n => {
            *direction = Direction::Right;
            (x1 - 1, y1 - 1)
        }
        (false, _, Direction::Down) => {
            *direction = Direction::Left;
            (x1 + 1, y1 + 1)
        }
        (false, _, _) => {
            *direction = Direction::Left;
            (x1 - 1, y1 + 1)
        }
    }
}

fn compute_border(red_tiles: &[(i64, i64)]) -> Vec<(i64, i64)> {
    let len = red_tiles.len();
    let mut border: Vec<(i64, i64)> = Vec::new();
    let mut direction = initial_direction(red_tiles[len - 1], red_tiles[0]);

    for left in 0..len {
        let (x1, y1) = red_tiles[left];
        let (x1_n, y1_n) = red_tiles[(left + 1) % len];
        border.push(border_corner(x1, y1, x1_n, y1_n, &mut direction));
    }
    border
}

fn line_intersects_rect(
    rect_a: (i64, i64),
    rect_b: (i64, i64),
    line_a: (i64, i64),
    line_b: (i64, i64),
) -> bool {
    let (rx1, rx2) = (rect_a.0.min(rect_b.0), rect_a.0.max(rect_b.0));
    let (ry1, ry2) = (rect_a.1.min(rect_b.1), rect_a.1.max(rect_b.1));
    let (lx1, lx2) = (line_a.0.min(line_b.0), line_a.0.max(line_b.0));
    let (ly1, ly2) = (line_a.1.min(line_b.1), line_a.1.max(line_b.1));

    if ly1 == ly2 {
        return ly1 >= ry1 && ly1 <= ry2 && lx2 >= rx1 && lx1 <= rx2;
    }
    if lx1 == lx2 {
        return lx1 >= rx1 && lx1 <= rx2 && ly2 >= ry1 && ly1 <= ry2;
    }
    false
}

fn parse_input(input: &str) -> Vec<(i64, i64)> {
    input
        .lines()
        .map(|l| {
            let (x, y) = l.split_once(',').unwrap();
            (
                x.parse::<i64>().ok().unwrap(),
                y.parse::<i64>().ok().unwrap(),
            )
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        7,1\n\
        11,1\n\
        11,7\n\
        9,7\n\
        9,5\n\
        2,5\n\
        2,3\n\
        7,3";

    #[test]
    fn solves_first() {
        assert_eq_number(50, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(24, solve_second(String::from(RAW_INPUT)));
    }
}
