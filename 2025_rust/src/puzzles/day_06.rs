use super::Result;

#[derive(PartialEq)]
enum Operator {
    Add,
    Multiply,
}

pub fn solve_first(input: String) -> Result {
    let (values, operators) = parse_input_first(&input);
    solve(values, operators)
}

pub fn solve_second(input: String) -> Result {
    let (values, operators) = parse_input_second(&input);
    solve(values, operators)
}

fn solve(values: Vec<Vec<u64>>, operators: Vec<Operator>) -> Result {
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

fn parse_input_first(input: &str) -> (Vec<Vec<u64>>, Vec<Operator>) {
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

fn parse_input_second(input: &str) -> (Vec<Vec<u64>>, Vec<Operator>) {
    let mut values: Vec<Vec<u64>> = Vec::new();
    let mut operators = Vec::new();

    let mut raw_number_lines = Vec::new();
    let mut raw_operators: &[u8] = b"";
    for line in input.lines() {
        if line.starts_with('*') || line.starts_with('+') {
            raw_operators = line.as_bytes();
        } else {
            raw_number_lines.push(line.as_bytes());
        }
    }
    let mut i = 0;
    let mut start_i;
    while i < raw_operators.len() {
        if b'+' == raw_operators[i] {
            operators.push(Operator::Add);
        } else {
            operators.push(Operator::Multiply);
        }
        start_i = i;
        i += 1;
        while i < raw_operators.len() && b' ' == raw_operators[i] {
            i += 1;
        }
        let end_i = if i < raw_operators.len() { i - 1 } else { i };
        let mut numbers = Vec::new();
        for j in start_i..end_i {
            let mut n = 0_u64;
            for raw_numbers in raw_number_lines.iter() {
                if b' ' != raw_numbers[j] {
                    n = n * 10 + u64::from(raw_numbers[j] - b'0');
                }
            }
            numbers.push(n);
        }
        values.push(numbers);
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

    static RAW_INPUT: &str = "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  ";

    #[test]
    fn solves_first() {
        assert_eq_number(4277556, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(3263827, solve_second(String::from(RAW_INPUT)));
    }
}
