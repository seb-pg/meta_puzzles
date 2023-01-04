#![allow(non_snake_case)]

pub fn getMaxAdditionalDinersCount(N: i64, K: i64, _M: i32, S: &Vec<i64>) -> i64 {
    let d: i64 = K + 1;

    let mut taken: Vec<i64> = Vec::with_capacity(S.len() + 1);
    taken.push(-K);  // we are adding "fake" seats at the beginning
    taken.extend_from_slice(&S);
    taken.push(N + d);  // we are adding "fake" seats at the end

    // we sort elements of S: O(M * log(M))
    taken.sort();

    // we are calculating the extra seats available between each consecutive seats: O(M)
    let mut nb: i64 = 0;
    let e = taken.len() - 1;
    for i in 0..e {
        nb += (taken[i + 1] - taken[i] - d) / d;
    }
    return nb;
}
