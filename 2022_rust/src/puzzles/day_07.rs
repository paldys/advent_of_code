use std::collections::HashMap;

use lazy_static::lazy_static;
use regex::Regex;

use super::Result;

struct Directory {
    content: HashMap<String, Directory>,
    size: u32,
}

pub fn solve_first(input: String) -> Result {
    let root_directory = parse_input(input);
    Result::Number(sum_dir_sizes_below(&root_directory, 100_000))
}

// assuming we cd into every directory only once and ls them only once
fn parse_input(input: String) -> Directory {
    let mut input_lines: Vec<&str> = input.trim_end().split('\n').collect();
    input_lines.reverse();
    if let Some("$ cd /") = input_lines.pop() {
        let mut root_directory = create_directory();

        parse_next_line(&mut root_directory, &mut input_lines);

        return root_directory;
    }

    panic!("Input should start with root directory")
}

fn sum_dir_sizes_below(directory: &Directory, limit: u32) -> u32 {
    let mut sum_size = 0;
    let Directory { content, size } = directory;
    if *size < limit {
        sum_size += size;
    }
    for child_directory in content.values() {
        sum_size += sum_dir_sizes_below(child_directory, limit)
    }
    sum_size
}

fn parse_next_line(directory: &mut Directory, input_lines: &mut Vec<&str>) -> u32 {
    let Directory {
        ref mut content,
        ref mut size,
    } = directory;

    loop {
        if input_lines.is_empty() {
            return *size;
        }
        let input_line = input_lines.pop().unwrap();
        let input_line_parts: Vec<&str> = input_line.split(' ').collect();
        match input_line_parts[1] {
            "cd" => {
                let next_directory_name = input_line_parts[2];
                if ".." == next_directory_name {
                    return *size;
                }
                let next_directory = content
                    .get_mut(next_directory_name)
                    .expect("Unknown directory");
                *size += parse_next_line(next_directory, input_lines);
            }
            "ls" => {
                *size += parse_after_ls(content, input_lines);
            }
            _ => panic!("Unexpected command found"),
        }
    }
}

fn parse_after_ls(content: &mut HashMap<String, Directory>, input_lines: &mut Vec<&str>) -> u32 {
    lazy_static! {
        static ref LS_OUTPUT_RE: Regex = Regex::new(r"^(\d+|dir) ([a-z\.]+)$").unwrap();
    }
    let mut sum_size = 0;
    loop {
        if input_lines.is_empty() {
            break;
        }
        let &input_line = input_lines.last().unwrap();
        if input_line.starts_with('$') {
            break;
        }
        let input_line = input_lines.pop().unwrap();
        let captures = LS_OUTPUT_RE
            .captures(input_line)
            .expect("Input line is not of expected format");
        let dir_or_size = captures.get(1).expect("Match expected").as_str();
        let name = captures.get(2).expect("Match expected").as_str();
        match dir_or_size {
            "dir" => {
                content.insert(String::from(name), create_directory());
            }
            size => {
                let size: u32 = size.parse().expect("Expected number here");
                sum_size += size;
            }
        };
    }
    sum_size
}

fn create_directory() -> Directory {
    Directory {
        content: HashMap::new(),
        size: 0,
    }
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "$ cd /\n\
    $ ls\n\
    dir a\n\
    14848514 b.txt\n\
    8504156 c.dat\n\
    dir d\n\
    $ cd a\n\
    $ ls\n\
    dir e\n\
    29116 f\n\
    2557 g\n\
    62596 h.lst\n\
    $ cd e\n\
    $ ls\n\
    584 i\n\
    $ cd ..\n\
    $ cd ..\n\
    $ cd d\n\
    $ ls\n\
    4060174 j\n\
    8033020 d.log\n\
    5626152 d.ext\n\
    7214296 k\n";

    #[test]
    fn solves_first() {
        assert_eq_number(95437, solve_first(String::from(RAW_INPUT)));
    }
}
