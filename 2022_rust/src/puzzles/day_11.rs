use core::str::FromStr;

use super::Result;

#[derive(Debug)]
enum Operation {
    Add(u64),
    Multiply(u64),
    Sqr(),
}

#[derive(Debug)]
struct Monkey {
    items: Vec<u64>,
    operation: Operation,
    divisible_by: u64,
    on_true: usize,
    on_false: usize,
    inspected: u32,
}

pub fn solve_first(input: String) -> Result {
    let mut monkeys = parse_input(input);
    for _ in 0..20 {
        for i in 0..monkeys.len() {
            let monkey = &mut monkeys[i];
            let items_to: Vec<(usize, u64)> = monkey
                .items
                .iter()
                .map(|item| {
                    let item = match monkey.operation {
                        Operation::Add(n) => *item + n,
                        Operation::Multiply(n) => *item * n,
                        Operation::Sqr() => *item * *item,
                    } / 3;
                    let to_monkey = if item % monkey.divisible_by == 0 {
                        monkey.on_true
                    } else {
                        monkey.on_false
                    };
                    (to_monkey, item)
                })
                .collect();
            monkey.items.clear();
            monkey.inspected += items_to.len() as u32;
            for (to, item) in items_to {
                monkeys[to].items.push(item);
            }
        }
    }
    monkeys.sort_by_key(|m| m.inspected);
    monkeys.reverse();
    let monkey_business = monkeys.iter().take(2).map(|m| m.inspected).product();
    Result::Number(monkey_business)
}

fn parse_input(input: String) -> Vec<Monkey> {
    let mut monkeys = Vec::new();
    let mut lines = input.trim_end().lines();
    loop {
        if lines.next().is_none() {
            break;
        }
        let items = lines.next().map(parse_items).unwrap();
        let operation = lines.next().map(parse_operation).unwrap();
        let divisible_by = parse_end(lines.next(), "  Test: divisible by ");
        let on_true = parse_end(lines.next(), "    If true: throw to monkey ");
        let on_false = parse_end(lines.next(), "    If false: throw to monkey ");
        monkeys.push(Monkey {
            items,
            operation,
            divisible_by,
            on_true,
            on_false,
            inspected: 0,
        });
        lines.next();
    }
    monkeys
}

fn parse_items(line: &str) -> Vec<u64> {
    line.trim_start_matches("  Starting items: ")
        .split(", ")
        .map(|i| i.parse().unwrap())
        .collect()
}

fn parse_operation(line: &str) -> Operation {
    let op = line.trim_start_matches("  Operation: new = old ");
    if op == "* old" {
        Operation::Sqr()
    } else if op.starts_with('*') {
        Operation::Multiply(op.trim_start_matches("* ").parse().unwrap())
    } else {
        Operation::Add(op.trim_start_matches("+ ").parse().unwrap())
    }
}

fn parse_end<T: FromStr>(line: Option<&str>, prefix: &str) -> T
where
    <T as FromStr>::Err: std::fmt::Debug,
{
    line.unwrap().trim_start_matches(prefix).parse().unwrap()
}

#[cfg(test)]
mod tests {
    use crate::input_utils::get_test_input;
    use crate::puzzles::assert_eq_number;

    use super::*;

    #[test]
    fn solves_first() {
        assert_eq_number(10605, solve_first(get_test_input(11)));
    }
}
