#![allow(non_snake_case)]

use std::cmp;
use std::hash::{Hash, Hasher};

#[derive(Eq)]
struct Dials
{
    dial1: i32,
    dial2: i32,
}

impl PartialEq for Dials {
    fn eq(&self, other: &Self) -> bool {
        return self.dial1 == other.dial1 && self.dial2 == other.dial2;
    }
}

impl Hash for Dials {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.dial1.hash(state);
        self.dial2.hash(state);
    }
}

type SolutionsT = std::collections::HashMap<Dials, i64>;

fn get_distance(target: i32, position: i32, N: i32) -> i32 {
    let mut positive_move = (target - position) % N;
    if positive_move < 0 {
        positive_move += N;
    }
    let negative_move = N - positive_move;  // positive number
    return cmp::min(positive_move, negative_move);
}

fn insert_solution(new_solutions: &mut SolutionsT, N: i32, target: i32, dial1: i32, dial2: i32, distance: i64)
{
    let new_distance = distance + get_distance(target, dial1, N) as i64;
    let key = Dials{ dial1: cmp::min(dial2, target), dial2: cmp::max(dial2, target) };
    let it = new_solutions.get(&key);
    let value = it.unwrap_or(&i64::MAX);
    new_solutions.insert(key, cmp::min(*value, new_distance));
}

pub fn getMinCodeEntryTime(N: i32, _M: i32, C: &Vec<i32>) -> i64 {
    if C.is_empty() {
        return 0;
    }
    let max_value = i64::MAX;
    let mut solutions = SolutionsT::default();
    solutions.insert(Dials{ dial1: 1, dial2: 1 }, 0);
    for &target in C {
        let mut new_solutions = SolutionsT::default();
        for (dials, &distance) in &solutions {
            // we turn dial1
            insert_solution(&mut new_solutions, N, target, dials.dial1, dials.dial2, distance);
            // we turn dial2
            insert_solution(&mut new_solutions, N, target, dials.dial2, dials.dial1, distance);
        }
        solutions = new_solutions;
    }
    let mut min_distance = max_value;
    for (_, &distance) in &solutions {
        min_distance = cmp::min(min_distance, distance);
    }
    return min_distance;
}
