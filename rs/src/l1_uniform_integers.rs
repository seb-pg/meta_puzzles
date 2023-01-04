#![allow(non_snake_case)]

fn len_str(_nb: i64) -> i32 {
    if _nb == 0 {  // not necessary due to problem definition
        return 1;
    }
    let mut nb = _nb;
    let mut ret: i32 = 0;
    while nb > 0 {
        nb /= 10;
        ret += 1;
    }
    return ret;
}

fn ones(log_value: i32) -> i64 {
    let mut ret: i64 = 0;
    let mut i = 0;
    while i < log_value {
        i += 1;
        ret = ret * 10 + 1;
    }
    return ret;
}

pub fn getMinimumDeflatedDiscCount(A: i64, B: i64) -> i32 {
    // Each of the following lines is O(log(max(A, B)))
    let len_a = len_str(A);
    let len_b = len_str(B);
    let tmp_a = ones(len_a);
    let tmp_b = ones(len_b);
    
    // Everything else is O(1)
    let nb_a = (tmp_a * 10 - A) / tmp_a;
    let nb_b = B / tmp_b;
    let nb_m = if len_b - len_a >= 2 { 9 * (len_b - len_a - 1) } else { 0 } as i64;
    let mut nb = nb_a + nb_m + nb_b;
    if len_a == len_b {
        nb -= 9;
    }
    return nb as i32;
}
