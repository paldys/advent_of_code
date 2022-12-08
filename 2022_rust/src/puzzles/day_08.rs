use super::Result;

pub fn solve_first(input: String) -> Result {
    let forest: Vec<&[u8]> = input
        .trim_end()
        .split('\n')
        .map(|line| line.as_bytes())
        .collect();
    let forest_width = forest[0].len();
    let forest_height = forest.len();
    let mut visibility: Vec<Vec<bool>> = vec![vec![false; forest[0].len()]; forest.len()];
    for i in 0..forest_height {
        let mut max_height = 0;
        for j in 0..forest_width {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for i in 0..forest_height {
        let mut max_height = 0;
        for j in (0..forest_width).rev() {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for j in 0..forest_width {
        let mut max_height = 0;
        for i in 0..forest_height {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for j in 0..forest_width {
        let mut max_height = 0;
        for i in (0..forest_height).rev() {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }

    let visible_trees = visibility
        .iter()
        .flat_map(|l| l.iter().copied())
        .filter(|v| *v)
        .count();

    Result::Number(visible_trees as u32)
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "30373\n\
    25512\n\
    65332\n\
    33549\n\
    35390\n";

    #[test]
    fn solves_first() {
        assert_eq_number(21, solve_first(String::from(RAW_INPUT)));
    }
}
