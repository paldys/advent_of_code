#![feature(iter_array_chunks, iter_order_by)]

use clap::Parser;

pub mod input_utils;
pub mod puzzles;
pub mod utils;

#[derive(Parser)]
struct Args {
    /// The day of the puzzle
    day: usize,
    /// The part of the puzzle
    part: u8,
}

fn main() {
    let args = Args::parse();

    println!("Solve Day {} Puzzle Part {}", args.day, args.part);

    let puzzles = puzzles::get_all_puzzles();

    if args.day == 0 || puzzles.len() - 1 < args.day {
        panic!("Invalid day provided")
    }

    let days_puzzle = puzzles[args.day - 1];

    let solver = match args.part {
        1 => days_puzzle.0,
        2 => days_puzzle.1,
        _ => panic!("Invalid part provided"),
    };

    let input = input_utils::get_input(args.day);

    match solver(input) {
        puzzles::Result::Number(number) => println!("Answer: {number}"),
        puzzles::Result::String(string) => println!("Answer: {string}"),
    }
}
