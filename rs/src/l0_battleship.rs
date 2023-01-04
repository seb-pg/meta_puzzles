#![allow(non_snake_case)]

pub fn getHitProbability(R: i32, C: i32, G: &Vec<Vec<i32>>) -> f64 {
    let sum = G.iter().fold(0, |acc, row| acc + row.iter().sum::<i32>());
    let div = R * C;
    return (sum as f64) / (div as f64);
}
