use clap::Parser;
use std::fs;

pub mod puzzles;

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

    let file_name = format!("resources/day_{:0>2}_input.txt", args.day);
    let days_puzzle = puzzles[args.day - 1];

    let solver = match args.part {
        1 => days_puzzle.0,
        2 => days_puzzle.1,
        _ => panic!("Invalid part provided"),
    };

    let input = fs::read_to_string(file_name).expect("Could not read input");
    let answer = solver(input);

    println!("Answer: {}", answer)
}
