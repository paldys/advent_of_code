use super::Result;

#[derive(PartialEq)]
enum Operator {
    Add,
    Multiply,
}

pub fn solve_first(input: String) -> Result {
    let (values, operators) = parse_input(&input);
    let s = values
        .iter()
        .zip(&operators)
        .map(|(v, o)| match o {
            Operator::Add => v.iter().sum::<u64>(),
            Operator::Multiply => v.iter().product(),
        })
        .sum();
    Result::Number(s)
}

fn parse_input(input: &str) -> (Vec<Vec<u64>>, Vec<Operator>) {
    let mut values: Vec<Vec<u64>> = Vec::new();
    let mut operators = Vec::new();
    for line in input.lines() {
        if line.starts_with('*') || line.starts_with('+') {
            operators = parse_operators(line);
        } else {
            for (i, &v) in parse_numbers(line).iter().enumerate() {
                if let Some(vs) = values.get_mut(i) {
                    vs.push(v);
                } else {
                    let vs = vec![v];
                    values.push(vs);
                }
            }
        }
    }
    (values, operators)
}

fn parse_numbers(input: &str) -> Vec<u64> {
    input
        .split_whitespace()
        .map(|s| s.parse::<u64>().unwrap())
        .collect()
}

fn parse_operators(input: &str) -> Vec<Operator> {
    input
        .split_whitespace()
        .map(|s| {
            if s == "+" {
                Operator::Add
            } else {
                Operator::Multiply
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        123 328  51 64 \n\
        45 64  387 23 \n\
        6 98  215 314\n\
        *   +   *   +  ";

    #[test]
    fn solves_first() {
        assert_eq_number(4277556, solve_first(String::from(RAW_INPUT)));
    }
}
