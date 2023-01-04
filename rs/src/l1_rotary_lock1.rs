#![allow(non_snake_case)]

pub fn getMinCodeEntryTime(N: i32, _M: i32, C: &Vec<i32>) -> i64 {
    use std::cmp;

    let mut pos: i32 = 1;
    let mut nb: i64 = 0;
    for &target in C {
        let mut positive_move = (target - pos) % N;  // positive move
        positive_move = if positive_move < 0 { positive_move + N } else { positive_move};  // modulo can be negative in C++
        let negative_move = N - positive_move;
        nb += cmp::min(positive_move, negative_move) as i64;
        pos = target;
    }
    return nb;
}
