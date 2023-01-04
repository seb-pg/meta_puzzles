#![allow(non_snake_case)]

pub fn getWrongAnswers(_N: i32, C: &str) -> String {
    // We are not using something like match c { 'A' => 'B', 'B' => 'A', _ => c }

    // Alternative 1
    let mut ret: String = String::with_capacity(C.len());
    for c in C.chars() {
        ret.push(if c == 'A' {'B'} else {'A'});
    }
    return ret;

    // Alternative 2 (one liner, no "reserve")
    //return String::from_iter(C.chars().map(|c| if c == 'A' {'B'} else {'A'}));
}
