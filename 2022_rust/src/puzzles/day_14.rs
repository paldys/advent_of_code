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

    let mut sand_count = 0;

    'outer: loop {
        let mut sand_x = SAND_FALL_POSITION - min_x;
        let mut sand_y = 0;
        loop {
            if sand_y == max_y {
                break 'outer;
            }
            if !cave[sand_y + 1][sand_x] {
                sand_y += 1;
            } else if !cave[sand_y + 1][sand_x - 1] {
                sand_x -= 1;
                sand_y += 1;
            } else if !cave[sand_y + 1][sand_x + 1] {
                sand_x += 1;
                sand_y += 1;
            } else {
                cave[sand_y][sand_x] = true;
                break;
            }
        }
        sand_count += 1;
    }

    Result::Number(sand_count)
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
}
