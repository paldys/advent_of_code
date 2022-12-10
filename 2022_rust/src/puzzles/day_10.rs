use super::Result;

const INTERESTING_SIGNAL_START: i32 = 20;
const SIGNAL_CYCLE: i32 = 40;

#[derive(Clone, Debug)]
enum Instruction {
    Addx(i32),
    Noop,
}

pub fn solve_first(input: String) -> Result {
    let mut strengths = 0;
    let mut to_add = INTERESTING_SIGNAL_START;
    let mut x = 1;
    let mut i = 1;
    for instruction in parse_input(input) {
        match instruction {
            Instruction::Noop => {
                i += 1;
                check_to_save(i, x, &mut to_add, &mut strengths);
            }
            Instruction::Addx(n) => {
                i += 1;
                check_to_save(i, x, &mut to_add, &mut strengths);
                i += 1;
                x += n;
                check_to_save(i, x, &mut to_add, &mut strengths);
            }
        }
    }
    Result::Number(strengths as u32)
}

pub fn solve_second(input: String) -> Result {
    let mut crt_screen = String::from("");
    let mut x = 1;
    let mut i = 1;

    for instruction in parse_input(input) {
        match instruction {
            Instruction::Noop => {
                draw_to_crt(i, x, &mut crt_screen);
                i += 1;
            }
            Instruction::Addx(n) => {
                draw_to_crt(i, x, &mut crt_screen);
                i += 1;
                draw_to_crt(i, x, &mut crt_screen);
                i += 1;
                x += n;
            }
        }
    }
    Result::String(crt_screen)
}

fn draw_to_crt(signal_index: i32, register_x: i32, crt_screen: &mut String) {
    let normalized_index = (signal_index - 1) % SIGNAL_CYCLE;
    if normalized_index == 0 {
        crt_screen.push('\n');
    }
    let c = if (register_x - normalized_index).abs() <= 1 {
        '#'
    } else {
        '.'
    };
    crt_screen.push(c);
}

fn check_to_save(
    signal_index: i32,
    register_x: i32,
    signal_to_save: &mut i32,
    signal_strengths: &mut i32,
) {
    if signal_index == *signal_to_save {
        *signal_to_save += SIGNAL_CYCLE;
        *signal_strengths += signal_index * register_x;
    }
}

fn parse_input(input: String) -> Vec<Instruction> {
    input
        .trim_end()
        .split('\n')
        .map(|line| match line {
            "noop" => Instruction::Noop,
            line => {
                let line: Vec<&str> = line.split(' ').collect();
                if line[0] != "addx" {
                    panic!("Unknown instruction")
                }
                let number: i32 = line[1].parse().unwrap();
                Instruction::Addx(number)
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::input_utils::get_test_input;
    use crate::puzzles::{assert_eq_number, assert_eq_string};

    use super::*;

    static RAW_OUTPUT: &str = "\n\
    ##..##..##..##..##..##..##..##..##..##..\n\
    ###...###...###...###...###...###...###.\n\
    ####....####....####....####....####....\n\
    #####.....#####.....#####.....#####.....\n\
    ######......######......######......####\n\
    #######.......#######.......#######.....";

    #[test]
    fn solves_first() {
        assert_eq_number(13140, solve_first(get_test_input(10)));
    }

    #[test]
    fn solves_second() {
        assert_eq_string(String::from(RAW_OUTPUT), solve_second(get_test_input(10)));
    }
}
