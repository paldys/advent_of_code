use clap::Parser;
use std::fs;

pub mod puzzles;

#[derive(Parser)]
struct Args {
    /// The day of the puzzle
    day: u8,
    /// The number of the puzzle
    puzzle: u8,
}

fn main() {
    let args = Args::parse();

    println!("Solve Day 1 Puzzle {}", args.puzzle);

    let day_01_input =
        fs::read_to_string("resources/day_01_input.txt").expect("Could not read input");

    let answer = if args.puzzle == 1 {
        puzzles::day_01::solve_first(day_01_input)
    } else {
        puzzles::day_01::solve_second(day_01_input)
    };

    println!("Answer: {}", answer)
}
