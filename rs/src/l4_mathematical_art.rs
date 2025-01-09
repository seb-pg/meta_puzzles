// meta_puzzles by Sebastien Rubens
//
// This file is part of https://github.com/seb-pg/meta_puzzles
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// meta_puzzles has waived all copyright and related or neighboring rights
// to meta_puzzles.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

#![allow(non_snake_case)]

use std::collections::BTreeSet;
use std::ops::Bound;

type Stroke = (i64, i64, i64);

fn read_strokes(N: usize, L: &Vec<i64>, D: &str) -> (Vec::<Stroke>, Vec::<Stroke>) {
    let mut hor_strokes = Vec::<Stroke>::with_capacity(2 * N);
    let mut ver_strokes = Vec::<Stroke>::with_capacity(2 * N);

    let mut x0: i64 = 0;
    let mut y0: i64 = 0;
    let mut x1: i64 = 0;
    let mut y1: i64 = 0;
    for i in 0..N {
        let length = L[i];
        let direction = D.chars().nth(i).unwrap();
        if direction == 'R' {
            x1 = x0 + length;
            y1 = y0;
            hor_strokes.push(( y0, x0, -1 ));
            hor_strokes.push(( y0, x1, 1 ));
        }
        else if direction == 'L' {
            x1 = x0 - length;
            y1 = y0;
            hor_strokes.push(( y0, x1, -1 ));
            hor_strokes.push(( y0, x0, 1 ));
        }
        else if direction == 'U' {
            x1 = x0;
            y1 = y0 + length;
            ver_strokes.push(( x0, y0, -1 ));
            ver_strokes.push(( x0, y1, 1 ));
        }
        else if direction == 'D' {
            x1 = x0;
            y1 = y0 - length;
            ver_strokes.push(( x0, y1, -1 ));
            ver_strokes.push(( x0, y0, 1 ));
        }
        x0 = x1;
        y0 = y1;

    }
    return (hor_strokes, ver_strokes);
}

fn merge_strokes(strokes: &Vec::<Stroke>) -> Vec::<Stroke>
{
    // Complexity: O(N)
    if strokes.is_empty() {
        return Vec::<Stroke>::with_capacity(0);
    }
    // This code cannot replicate what the C++ is doing because, as far as I am aware,
    // Rust will not allow have both an mutable and immutable borrow on strokes.
    // While we would not have to allocate an additional vector in C++, we will have to in Rust
    let mut strokes_out = Vec::<Stroke>::with_capacity(2 * strokes.len());
    let mut strokes_it = strokes.iter();
    let (mut x0, mut y0, mut total) = strokes_it.next().unwrap();
    for it in strokes_it {
        let (x1, y1, inc) = *it;
        if x0 != x1 {
            x0 = x1;
            y0 = y1;
            total = inc;
            continue;
        }
        if total == 0 {
            y0 = y1;
        }
        total += inc;
        if total == 0 {
            strokes_out.push(( x0, y0, y1 ));
        }
    }
    return strokes_out;
}

fn distance(container: &BTreeSet::<(i64, i64)>, y0: &(i64, i64), y1: &(i64, i64)) -> i64
{
    if container.is_empty() {
        return 0;
    }
    let lo = container.first().unwrap();
    let hi = container.last().unwrap();
    if y1 < lo || y0 > hi {
        return 0;
    }
    if y0 < lo && hi < y1 {
        return container.len() as i64;
    }
    // Note on performance / complexity:
    // I do not know if the count() operation is O(n) or O(log(n))
    // Should it be O(n), the same optimisation as in C++ should be used
    let nb = container.range((Bound::Excluded(y0), Bound::Excluded(y1))).count() as i64;
    return nb;
}

fn count_crosses_impl(ver_strokes: &Vec::<Stroke>, hor_strokes: &Vec::<Stroke>) -> i64 {
    // we need to create a list of height to insert(we cannot have consecutive x's for a given height)
    // O(n * log(N))
    let mut hor_strokes_in = Vec::<Stroke>::with_capacity(hor_strokes.len());
    let mut hor_strokes_out = Vec::<Stroke>::with_capacity(hor_strokes.len());
    for it in hor_strokes.iter() {
        let (h, x0, x1) = *it;
        hor_strokes_in.push(( x0, h, x1 ));
        hor_strokes_out.push(( x1, h, x0 ));
    }
    hor_strokes_in.sort();
    hor_strokes_out.sort();

    // count crosses
    let mut nb: i64 = 0;
    let mut heights = BTreeSet::<(i64, i64)>::from([]);
    let mut it_in = hor_strokes_in.iter().peekable();
    let mut it_out = hor_strokes_out.iter().peekable();
    for it in ver_strokes.iter() {
        let (hpos, y0, y1) = *it;
        while let Some(next) = it_in.peek() {
            let (x0, vpos, _x1) = *next;
            let (x0, vpos) = (*x0, *vpos);
            if hpos <= x0 {
                break;
            }
            heights.insert((vpos, x0));
            it_in.next();
        }
        // remove output heights
        while let Some(next) = it_out.peek() {
            let (x1, vpos, x0) = *next;
            let (x1, vpos, x0) = (*x1, *vpos, *x0);
            if hpos < x1 {
                break;
            }
            heights.remove(&(vpos, x0));
            it_out.next();
        }
        nb += distance(&heights, &(y0, 0), &(y1, 0));
    }
    return nb;
}

fn count_crosses(ver_strokes: &Vec::<Stroke>, hor_strokes: &Vec::<Stroke>) -> i64 {
    // Complexity: O(N*log(N))
    if ver_strokes.len() * hor_strokes.len() == 0 {
        return 0;
    }

    // ver_strokes is chosen to be the smallest container
    // the reason is we will iterate over ver_strokes, while we will use log-time operation on hor_strokes
    if ver_strokes.len() > hor_strokes.len() {
        return count_crosses_impl(&hor_strokes, &ver_strokes);
    }
    else {
        return count_crosses_impl(&ver_strokes, &hor_strokes);
    }
}

pub fn getPlusSignCount(N: usize, L: &Vec<i64>, D: &str) -> i64 {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=587690079288608
    // Constraints:
    //   2 ≤ N ≤ 2,000
    //   1 ≤ Li ≤ 1,000,000,000
    //   Di ∈ {U, D, L, R}
    // Complexity: O(N*log(N))

    // O(N)
    let (mut hor_strokes, mut ver_strokes): (Vec::<Stroke>, Vec::<Stroke>) = read_strokes(N, L, D);
    if hor_strokes.is_empty() || ver_strokes.is_empty() {
        return 0;
    }

    // O(N * log(N))
    hor_strokes.sort();
    ver_strokes.sort();

    // O(N)
    let hor_strokes = merge_strokes(&hor_strokes);
    let ver_strokes = merge_strokes(&ver_strokes);

    // O(N * log(N))
    return count_crosses(&ver_strokes, &hor_strokes);
}

type RetType = i64;

struct Args
{
    L: Vec<i64>,
    D: &'static str,
    res: RetType,
}

impl super::Result<RetType> for Args {
    fn get_result(&self) -> RetType
    {
        return self.res;
    }
}

pub fn tests() -> u32
{
    let wrapper = |p: &Args| -> RetType { getPlusSignCount(p.L.len(), &p.L, &p.D) };

    let args_list : Vec<Args> = vec![
        // Meta
        Args{ L: vec![ 6, 3, 4, 5, 1, 6, 3, 3, 4 ], D: "ULDRULURD", res: 4 },
        Args{ L: vec![ 1, 1, 1, 1, 1, 1, 1, 1 ], D: "RDLUULDR", res: 1 },
        Args{ L: vec![ 1, 2, 2, 1, 1, 2, 2, 1 ], D: "UDUDLRLR", res: 1 },
        // extra1
        Args{ L: vec![ 1, 1, 1, 1, 1, 1 ], D: "RDURLU", res: 1 },
        Args{ L: vec![ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 ], D: "ULRUDRULUDLRD", res: 2 },
        Args{ L: vec![ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 ], D: "RDURLURDLRDUR", res: 2 },
    ];

    return super::run_all_tests("l4_mathematical_art", args_list, wrapper, Option::None);
}
