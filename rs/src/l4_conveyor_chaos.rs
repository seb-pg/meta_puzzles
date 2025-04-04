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

use std::cmp::Ordering;
use std::collections::BTreeMap;
use std::ops::Bound;
use std::rc::Rc;
use std::cell::RefCell;

type XType = i64;  // using f64 would create a "the trait `Ord` is not implemented for `f64`" because of sorting f64 in Rust

#[derive(Debug, Default)]
struct Params {
    x_min: XType,
    x_max: XType,
    h_min: i32,
    h_max: i32,
}

#[derive(Debug, Default)]
struct Drop {
    drop_point: XType,
    interval: Option<IntervalPtrT>,
}

#[derive(Debug, Default)]
struct Interval {
    n: u32,
    h: i32,
    xmin: XType,
    xmax: XType,
    children: Vec::<Drop>,
    weight: f64,
    costs: [f64; 2],
}

impl Interval {
    fn key(&self) -> (i32, u32) {
        (self.h, self.n)
    }

    fn width(&self) -> XType {
        self.xmax - self.xmin
    }

    fn middle(&self) -> XType {
        (self.xmax + self.xmin) / (2 as XType)
    }
}

impl PartialOrd for Interval {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.key().cmp(&other.key()))
    }
}

impl Ord for Interval {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

impl PartialEq for Interval {
    fn eq(&self, other: &Self) -> bool {
        self.h == other.h
    }
}

impl Eq for Interval {}

type IntervalPtrT = Rc<RefCell<Interval>>;
type ListIntervalsT = Vec<IntervalPtrT>;

fn build_intervals(N: u32, H: &[i32], A: &[i32], B: &[i32], params: &Params) -> ListIntervalsT {
    let G = N + 1;
    let mid = (params.h_max + params.h_min) as XType / (2 as XType);
    let mut intervals: ListIntervalsT = Vec::with_capacity((N + 2) as usize);

    // ground
    let ground_sp = Rc::new(RefCell::new(Interval {
        n: 0,
        h: params.h_min,
        xmin: params.x_min,
        xmax: params.x_max,
        ..Default::default()
    }));
    intervals.push(ground_sp.clone());

    // user intervals: O(N)
    for i in 0..N {
        intervals.push(Rc::new(RefCell::new(Interval {
            n: i + 1,
            h: H[i as usize],
            xmin: A[i as usize] as XType,
            xmax: B[i as usize] as XType,
            children: vec![Drop { drop_point: mid, interval: Some(ground_sp.clone()) },
                           Drop { drop_point: mid, interval: Some(ground_sp.clone()) }],
            ..Default::default()
        })));
    }

    // sky
    intervals.push(Rc::new(RefCell::new(Interval {
        n: G,
        h: params.h_max,
        xmin: params.x_min,
        xmax: params.x_max,
        children: vec![Drop { drop_point: mid, interval: Some(ground_sp.clone()) }],
        ..Default::default()
    })));

    // O(N*log(N))
    intervals.sort_by(|a, b| a.borrow().cmp(&b.borrow()));

    intervals
}

fn add_entries(N: usize, intervals: &mut ListIntervalsT) {
    let sky_sp = intervals.last().unwrap().clone(); // remove the last element (sky)
    let sky_h = sky_sp.borrow().h;

    let ground_sp = intervals.first().unwrap().clone();
    let ground = ground_sp.borrow();

    type Point = (XType, IntervalPtrT, i32);

    let subset = &intervals[1..intervals.len()-1];
    let mut points: Vec<Point> = subset.iter().map(|p| (p.borrow().xmin, p.clone(), 1)).collect();
    let points2: Vec<Point> = subset.iter().map(|p| (p.borrow().xmax, p.clone(), -1)).collect();
    points.extend(points2);

    points.sort_by_key(|k| (k.0, k.1.borrow().h)); // O(N*log(N))

    let mid = (ground.xmax + ground.xmin) / (2 as XType);
    intervals.pop();
    if points[0].0 > ground.xmin {
        intervals.push(Rc::new(RefCell::new(Interval {
                                n: 0, h: sky_h,
                                xmin: ground.xmin,
                                xmax: -1 as XType,
                                children: vec![Drop { drop_point: mid, interval: Some(ground_sp.clone()) }],
                                ..Default::default() })));
    }

    let mut stack: BTreeMap<(i32, u32), IntervalPtrT> = BTreeMap::new();
    stack.insert(ground_sp.borrow().key(), ground_sp.clone());
    let mut first = 0;
    let len_points = points.len();
    let mut last_n = u32::MAX;

    while first < len_points {
        let x = points[first].0;
        //let last = points.iter().position(|&(y, _, _)| y != x).unwrap_or(len_points);
        let start = first + 1;
        let last2 = points[start..].iter().position(|&(y, _, _)| y != x); //.unwrap_or(len_points);
        let last = last2.unwrap_or(points.len() - start) + start;
        let rows = &points[first..last];

        let p1 = stack.last_key_value().unwrap().1;
        let add_interval = last_n != p1.borrow().n;
        if add_interval {
            last_n = p1.borrow().n;
        }

        for (_, platform, op) in rows.iter() {
            let p = &mut platform.borrow_mut();
            let first = *stack.first_key_value().unwrap().0; // O(log(N))
            let last = p.key();
            let r = stack.range((Bound::Included(first), Bound::Excluded(last)));
            let prev = r.last().unwrap().1;
            if *op == -1 { // "remove" interval
                p.children[1] = Drop { drop_point: p.xmax, interval: Some(prev.clone()) };
                stack.remove(&p.key()); // O(log(N))
            } else if *op == 1 { // "add" interval
                p.children[0] = Drop { drop_point: p.xmin, interval: Some(prev.clone()) };
            }
        }

        for (_, p, op) in rows.iter() {
            if *op == 1 { // add interval
                //stack.insert(p.clone()); // O(log(N))
                stack.insert(p.borrow().key(), p.clone()); // O(log(N))
            }
        }

        let interval = Rc::new(RefCell::new(Interval {
            n: 0, h: sky_h, xmin: x as XType, xmax: -1 as XType,
            children: vec![Drop{ drop_point: 0, interval: Some(stack.last_key_value().unwrap().1.clone()) }],
                       ..Default::default() }));
        if !add_interval {
            intervals.pop();
        }
        intervals.push(interval); // create some space

        first = last;
    }

    if intervals.last().unwrap().borrow().xmin == ground.xmax {
        intervals.pop();
    }

    // stitching xmin and xmax
    let i1 = &intervals[N + 1..];
    let i2 = &intervals[N + 2..];
    for (e1, e2) in i1.iter().zip(i2.iter()) {
        e1.borrow_mut().xmax = e2.borrow().xmin;
    }
    intervals.last_mut().unwrap().borrow_mut().xmax = ground.xmax;

    // fix children by adding drop_point
    for (n, p) in intervals[N + 1..].iter().enumerate() {
        let q = &mut p.borrow_mut();
        q.n = (n + N) as u32;
        q.children[0] = Drop{ drop_point: q.middle(), interval: Some(q.children[0].interval.as_ref().unwrap().clone()) };
    }
}

fn populate_costs(N: usize, intervals: &mut ListIntervalsT) {
    // set up weight for entry interval from the sky: O(N)
    for platform_sp in intervals.iter_mut().skip(N + 1) {
        let p = &mut platform_sp.borrow_mut();
        p.weight = if p.children.first().unwrap().interval.as_ref().unwrap().borrow().n > 0 { p.width() as f64 } else { 0.0 };
    }

    // Accumulate costs from top to bottom: O(E) where E is 2*N at most
    let mut edges = Vec::new();
    for parent in intervals.iter_mut().skip(1).rev() {
        let weight = 0.5 * parent.borrow().weight;
        if weight == 0.0 {
            continue;
        }
        for (side, drop) in parent.borrow_mut().children.iter().enumerate() {
            let mut child = drop.interval.as_ref().unwrap().borrow_mut();
            if child.n > 0 {
                let drop_point = drop.drop_point;
                let cost_l = weight * (drop_point - child.xmin) as f64;
                let cost_r = weight * (child.xmax - drop_point) as f64;
                child.weight += weight;
                child.costs[0] += cost_l;
                child.costs[1] += cost_r;
                edges.push((parent.clone(), drop.interval.clone(), side, weight));
            }
        }
    }

    for (parent, child_sp, side, weight) in edges.iter().rev() {
        let child = child_sp.as_ref().unwrap().borrow();
        parent.borrow_mut().costs[*side] += (child.costs[0] + child.costs[1]) * weight / child.weight;
    }
}

fn calc_dist(N: usize, intervals: &ListIntervalsT) -> (f64, f64, usize, Option<IntervalPtrT>) {
    let base_cost: f64 = intervals[N + 1..].iter().map(|p| p.borrow().costs[0]).sum();

    let mut min_delta = 0.0;
    let mut min_dir = 0;
    let mut min_entry: Option<IntervalPtrT> = None;

    for entry_sp in &intervals[..=N] {
        let entry = entry_sp.borrow();
        let delta = entry.costs[0] - entry.costs[1];
        if min_delta > delta {
            min_delta = delta;
            min_dir = 0;
            min_entry = Some(entry_sp.clone());
            continue;
        }
        let delta = -delta;
        if min_delta > delta {
            min_delta = delta;
            min_dir = 1;
            min_entry = Some(entry_sp.clone());
        }
    }

    (base_cost, min_delta, min_dir, min_entry)
}

type RetType = f64;

struct Args
{
    H: Vec<i32>,
    A: Vec<i32>,
    B: Vec<i32>,
    res: RetType,
}

impl super::Result<RetType> for Args {
    fn get_result(&self) -> RetType
    {
        return self.res;
    }
}

fn get_min_expected_horizontal_travel_distance(N: usize, H: &[i32], A: &[i32], B: &[i32]) -> f64 {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=280063030479374
    // Constraints:
    //   1 ≤ N ≤ 500,000
    //   1 ≤ Hi ≤ 999,999
    //   1 ≤ Ai < Bi ≤ 1,000,000
    // Complexity: O(N*log(N))

    let params = Params{ x_min: 0, x_max: 1_000_000, h_min: 0, h_max: 1_000_000 };
    let mut intervals = build_intervals(N as u32, H, A, B, &params);
    add_entries(N, &mut intervals);
    populate_costs(N, &mut intervals);
    let (base_cost, min_delta, _, _) = calc_dist(N, &intervals);
    let smallest_cost = (base_cost + min_delta) / (1_000_000.0 - 0.0);
    smallest_cost
}

pub fn tests() -> u32
{
    let wrapper = |p: &Args| -> RetType { get_min_expected_horizontal_travel_distance(p.A.len(), &p.H, &p.A, &p.B) };

    let args_list : Vec<Args> = vec![
        // Meta
        Args{ H: vec![ 10, 20 ], A: vec![ 100000, 400000 ], B: vec![ 600000, 800000 ], res: 155000.0 },
        Args{ H: vec![ 2, 8, 5, 9, 4 ], A: vec![ 5000, 2000, 7000, 9000, 0 ], B: vec![ 7000, 8000, 11000, 11000, 4000 ], res: 36.5 },
        // extra1
        Args{ H: vec![ 2, 4, 5, 8, 9 ], A: vec![ 5000, 0, 7000, 2000, 9000 ], B: vec![ 7000, 4000, 11000, 8000, 11000 ], res: 36.5 },
        //
        Args{ H: vec![ 10 ], A: vec![ 0 ], B: vec![ 1_000_000 ], res: 500_000.0 },
        Args{ H: vec![ 10 ], A: vec![ 0 ], B: vec![ 500_000 ], res: 125_000.0 },
        Args{ H: vec![ 9 ], A: vec![ 500_000 ], B: vec![ 1_000_000 ], res: 125_000.0 },
        Args{ H: vec![ 10, 9 ], A: vec![ 0, 500_000 ], B: vec![ 500_000, 1_000_000 ], res: 250_000.0 },
        //
        Args{ H: vec![ 20, 10 ], A: vec![ 200000, 400000 ], B: vec![ 600000, 800000 ], res: 120_000.0 },
        Args{ H: vec![ 20, 10 ], A: vec![ 400000, 200000 ], B: vec![ 800000, 600000 ], res: 120_000.0 },
        Args{ H: vec![ 20, 20, 10 ], A: vec![ 100000, 500000, 200000 ], B: vec![ 300000, 700000, 600000 ], res: 100_000.0 },
        //
        Args{ H: vec![ 1 ], A: vec![ 0 ], B: vec![ 1_000_000 ], res: 500_000.0 },
        Args{ H: vec![ 1 ], A: vec![ 250_000 ], B: vec![ 750_000 ], res: 125_000.0 },
        Args{ H: vec![ 1, 3, 3, 5 ], A: vec![ 400_000, 200_000,  600_000, 400_000 ], B: vec![ 700_000, 500_000, 1000_000, 700_000 ], res: 213750.0 }, // direction=1 ; p=3 (base 247500.0)
        Args{ H: vec![ 1, 3, 3, 5, 7 ], A: vec![ 400_000, 200_000,  600_000, 400_000, 400_000 ], B: vec![ 700_000, 500_000, 1000_000, 700_000, 600_000 ], res: 215000.0 }, // direction=1 ; p=3 (base 247500.0)
    ];

    return super::run_all_tests("l4_conveyor_chaos", args_list, wrapper, Some(0.000_001));
}
