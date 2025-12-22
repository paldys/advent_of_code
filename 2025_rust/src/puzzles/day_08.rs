use super::Result;
use std::collections::{BTreeMap, BTreeSet};

struct Circuits {
    parent: Vec<usize>,
    size: Vec<usize>,
    length: usize,
}

impl Circuits {
    fn new(n: usize) -> Self {
        Self {
            parent: (0..n).collect(),
            size: vec![1; n],
            length: n,
        }
    }

    fn find(&mut self, x: usize) -> usize {
        if self.parent[x] != x {
            self.parent[x] = self.find(self.parent[x]);
        }
        self.parent[x]
    }

    fn merge(&mut self, a: usize, b: usize) {
        let ra = self.find(a);
        let rb = self.find(b);

        if ra == rb {
            return;
        }

        self.length -= 1;

        if self.size[ra] < self.size[rb] {
            self.parent[ra] = rb;
            self.size[rb] += self.size[ra];
        } else {
            self.parent[rb] = ra;
            self.size[ra] += self.size[rb];
        }
    }
}

pub fn solve_first(input: String) -> Result {
    solve_first_with_count(input, 1000)
}

fn solve_first_with_count(input: String, count: usize) -> Result {
    let points = parse_input(&input);
    let distances = get_distances(&points);
    let mut circuits = Circuits::new(points.len());
    for (_, &(left, right)) in distances.iter().take(count) {
        circuits.merge(left, right);
    }
    let mut circuit_sizes = BTreeSet::new();
    for (i, &p) in circuits.parent.iter().enumerate() {
        if i == p {
            circuit_sizes.insert(circuits.size[i]);
        }
    }
    let res: usize = circuit_sizes.iter().rev().take(3).product();
    Result::Number(res as u64)
}

pub fn solve_second(input: String) -> Result {
    let points = parse_input(&input);
    let distances = get_distances(&points);
    let mut circuits = Circuits::new(points.len());
    for (_, &(left, right)) in distances.iter() {
        circuits.merge(left, right);
        if circuits.length == 1 {
            return Result::Number((points[left].0 * points[right].0) as u64);
        }
    }
    unreachable!("should have found the end")
}

fn get_distances(points: &[(i64, i64, i64)]) -> BTreeMap<i64, (usize, usize)> {
    let mut distances = BTreeMap::new();
    for left in 0..points.len() {
        for right in (left + 1)..points.len() {
            let (x1, y1, z1) = points[left];
            let (x2, y2, z2) = points[right];
            let distance = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2);
            distances.insert(distance, (left, right));
        }
    }
    distances
}

fn parse_input(input: &str) -> Vec<(i64, i64, i64)> {
    input
        .lines()
        .map(|l| {
            let mut it = l.split(',').map(|x| x.parse::<i64>().ok());
            let x = it.next().unwrap().unwrap();
            let y = it.next().unwrap().unwrap();
            let z = it.next().unwrap().unwrap();
            (x, y, z)
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        162,817,812\n\
        57,618,57\n\
        906,360,560\n\
        592,479,940\n\
        352,342,300\n\
        466,668,158\n\
        542,29,236\n\
        431,825,988\n\
        739,650,466\n\
        52,470,668\n\
        216,146,977\n\
        819,987,18\n\
        117,168,530\n\
        805,96,715\n\
        346,949,466\n\
        970,615,88\n\
        941,993,340\n\
        862,61,35\n\
        984,92,344\n\
        425,690,689";

    #[test]
    fn solves_first() {
        assert_eq_number(40, solve_first_with_count(String::from(RAW_INPUT), 10));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(25272, solve_second(String::from(RAW_INPUT)));
    }
}
