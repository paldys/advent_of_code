use std::{cmp::max, vec};

use super::Result;

pub fn solve_first(input: String) -> Result {
    let points = parse_input(input);
    let (max_x, max_y, max_z) = find_max(&points);

    let mut scan = vec![vec![vec![false; max_x + 1]; max_y + 1]; max_z + 1];
    let mut surface_area = 0;

    for (x, y, z) in points {
        surface_area += 6;
        if x > 0 && scan[z][y][x - 1] {
            surface_area -= 2;
        }
        if y > 0 && scan[z][y - 1][x] {
            surface_area -= 2;
        }
        if z > 0 && scan[z - 1][y][x] {
            surface_area -= 2;
        }
        if x < max_x && scan[z][y][x + 1] {
            surface_area -= 2;
        }
        if y < max_y && scan[z][y + 1][x] {
            surface_area -= 2;
        }
        if z < max_z && scan[z + 1][y][x] {
            surface_area -= 2;
        }
        scan[z][y][x] = true;
    }

    Result::Number(surface_area)
}

fn find_max(points: &[(usize, usize, usize)]) -> (usize, usize, usize) {
    points
        .iter()
        .fold((0, 0, 0), |(max_x, max_y, max_z), (x, y, z)| {
            (max(max_x, *x), max(max_y, *y), max(max_z, *z))
        })
}

fn parse_input(input: String) -> Vec<(usize, usize, usize)> {
    input
        .trim_end()
        .split('\n')
        .map(|r| {
            let coordinates: Vec<&str> = r.split(',').collect();
            (
                coordinates[0].parse().unwrap(),
                coordinates[1].parse().unwrap(),
                coordinates[2].parse().unwrap(),
            )
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT_SIMPLE: &str = "1,1,1\n\
    2,1,1\n";

    static RAW_INPUT: &str = "2,2,2\n\
    1,2,2\n\
    3,2,2\n\
    2,1,2\n\
    2,3,2\n\
    2,2,1\n\
    2,2,3\n\
    2,2,4\n\
    2,2,6\n\
    1,2,5\n\
    3,2,5\n\
    2,1,5\n\
    2,3,5\n";

    #[test]
    fn solves_first() {
        assert_eq_number(10, solve_first(String::from(RAW_INPUT_SIMPLE)));
        assert_eq_number(64, solve_first(String::from(RAW_INPUT)));
    }
}
