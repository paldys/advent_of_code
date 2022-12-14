use std::cmp::{max, min};

use super::Result;

const SAND_FALL_POSITION: usize = 500;

pub fn solve_first(input: String) -> Result {
    let (rock_paths, min_x, max_x, max_y) = parse_input(input);
    let min_x = min_x - 1;
    let max_x = max_x + 1;
    let width = max_x - min_x;
    let mut cave: Vec<Vec<bool>> = vec![vec![false; width + 1]; max_y + 1];
    fill_rocks(&mut cave, rock_paths, min_x);

    let sand_count = simulate_sand(
        &mut cave,
        SAND_FALL_POSITION - min_x,
        0,
        Box::new(move |_, y| y == max_y),
    );

    Result::Number(sand_count)
}

pub fn solve_second(input: String) -> Result {
    let (rock_paths, min_x, max_x, max_y) = parse_input(input);
    let min_x = min(min_x, SAND_FALL_POSITION - max_y - 1) - 1;
    let max_x = max(max_x, SAND_FALL_POSITION + max_y + 1) + 1;
    let width = max_x - min_x;
    let depth = max_y + 2;
    let mut cave: Vec<Vec<bool>> = vec![vec![false; width + 1]; depth + 1];
    fill_rocks(&mut cave, rock_paths, min_x);
    fill_rocks(&mut cave, vec![vec![(0, depth), (width, depth)]], 0);

    let start_x = SAND_FALL_POSITION - min_x;
    let start_y = 0;

    let sand_count = simulate_sand(
        &mut cave,
        start_x,
        start_y,
        Box::new(move |x, y| x == start_x && y == start_y),
    );

    Result::Number(sand_count)
}

fn simulate_sand(
    cave: &mut [Vec<bool>],
    start_x: usize,
    start_y: usize,
    stop_at: Box<dyn Fn(usize, usize) -> bool>,
) -> u32 {
    let mut sand_count = 0;

    'outer: loop {
        let mut sand_x = start_x;
        let mut sand_y = start_y;
        loop {
            if !cave[sand_y + 1][sand_x] {
                sand_y += 1;
            } else if !cave[sand_y + 1][sand_x - 1] {
                sand_x -= 1;
                sand_y += 1;
            } else if !cave[sand_y + 1][sand_x + 1] {
                sand_x += 1;
                sand_y += 1;
            } else if !cave[sand_y][sand_x] {
                cave[sand_y][sand_x] = true;
                break;
            }
            if stop_at(sand_x, sand_y) {
                break 'outer;
            }
        }
        sand_count += 1;
    }

    sand_count
}

fn fill_rocks(cave: &mut [Vec<bool>], rock_paths: Vec<Vec<(usize, usize)>>, norm_x: usize) {
    for rock_path in rock_paths {
        let mut prev_rock = None;
        for rock in rock_path {
            match (prev_rock, rock) {
                (None, (x, y)) => {
                    cave[y][x - norm_x] = true;
                }
                (Some((x1, y1)), (x2, y2)) if x1 == x2 => {
                    for cave_l in cave.iter_mut().take(max(y1, y2) + 1).skip(min(y1, y2)) {
                        cave_l[x2 - norm_x] = true;
                    }
                }
                (Some((x1, y1)), (x2, y2)) if y1 == y2 => {
                    for i in min(x1, x2)..=max(x1, x2) {
                        cave[y1][i - norm_x] = true;
                    }
                }
                _ => panic!("Not a straight line"),
            }
            prev_rock = Some(rock)
        }
    }
}

type CaveProperties = (Vec<Vec<(usize, usize)>>, usize, usize, usize);

fn parse_input(input: String) -> CaveProperties {
    let mut min_x = SAND_FALL_POSITION;
    let mut max_x = SAND_FALL_POSITION;
    let mut max_y = 0;
    let rock_paths = input
        .trim_end()
        .split('\n')
        .map(|l| {
            l.split(" -> ")
                .map(|c| {
                    let (x, y) = c.split_once(',').unwrap();
                    let (x, y) = (x.parse().unwrap(), y.parse().unwrap());
                    if x < min_x {
                        min_x = x
                    }
                    if x > max_x {
                        max_x = x
                    }
                    if y > max_y {
                        max_y = y
                    }
                    (x, y)
                })
                .collect()
        })
        .collect();
    (rock_paths, min_x, max_x, max_y)
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "498,4 -> 498,6 -> 496,6\n\
    503,4 -> 502,4 -> 502,9 -> 494,9\n";

    #[test]
    fn solves_first() {
        assert_eq_number(24, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(93, solve_second(String::from(RAW_INPUT)));
    }
}
