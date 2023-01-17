// meta_puzzles by Sebastien Rubens
//
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

use std::cmp;
use std::rc::Rc;
use std::cell::RefCell;
use std::hash::{Hash, Hasher};

type IndexT = usize;
type VertexSP = Rc<RefCell<Vertex>>;
type ListVerticesT = Vec<VertexSP>;

const INDEX_NOT_SET: IndexT = IndexT::MAX;

#[derive(Debug, Clone)]
struct Vertex {
    nb: IndexT,
    weight: IndexT,  // 0 means unused
    children: ListVerticesT,

    // members for strongly connected components
    index: IndexT,
    low_link: IndexT,
    on_stack: bool,

    // members for dag construction
    target: Option<VertexSP>,

    // members for max length calculation
    inputs: IndexT,  // number of inputs for a given node
    max_len: IndexT,  // used for memoization of max_len at node level
}

impl Vertex {
    fn new(nb: IndexT) -> Vertex {
        Vertex{nb: nb, weight: 0, children: Vec::<VertexSP>::new(),
                index: INDEX_NOT_SET, low_link:INDEX_NOT_SET, on_stack: false,
                target: Option::<VertexSP>::None,
                inputs: 0, max_len: 0}
    }
}

#[derive(Copy, Clone, Debug, Eq)]
struct Edge
{
    v: IndexT,
    w: IndexT,
}

impl Ord for Edge {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        if self.v < other.v {
            return std::cmp::Ordering::Less;
        }
        else if self.v > other.v {
            return std::cmp::Ordering::Greater;
        }
        if self.w < other.w {
            return std::cmp::Ordering::Less;
        }
        else if self.w > other.w {
            return std::cmp::Ordering::Greater;
        }
        return  std::cmp::Ordering::Equal;
    }
}

impl PartialOrd for Edge {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Edge {
    fn eq(&self, other: &Self) -> bool {
        return self.v == other.v && self.w == other.w;
    }
}

impl Hash for Edge {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.v.hash(state);
        self.w.hash(state);
    }
}

fn keep_uniques(edges: &mut Vec<Edge>) {
    if edges.len() <= 1 {
        return
    }
    edges.sort();
    edges.dedup();
}

fn build_children(edges: &Vec<Edge>) -> ListVerticesT {
    // recalculate N as nb_vertices
    let max_elt = *edges.iter().max_by_key(|&x| cmp::max(x.v, x.w)).unwrap_or(&Edge{v: 0, w: 0});
    let nb_vertices = cmp::max(max_elt.v, max_elt.w);

    //
    let mut vertices = ListVerticesT::with_capacity(nb_vertices + 1);
    for i in 0..nb_vertices + 1 {
        vertices.push(Rc::new(RefCell::new(Vertex::new(i as IndexT))));
    }
    for edge in edges {
        let w = &vertices[edge.w];
        let mut _v = vertices[edge.v].borrow_mut();
        let mut _w = w.borrow_mut();
        _v.children.push(w.clone());
        _v.weight = 1;
        _w.weight = 1;
    }
    return vertices;
}

struct Tarjan {
    vertices: ListVerticesT,  // TODO: should be lifetime reference
    sccs: Vec<ListVerticesT>,
    stack: ListVerticesT,
    index: IndexT,
}

impl Tarjan {
    fn new(vertices: &ListVerticesT) -> Tarjan {
        //Tarjan{vertices: &vertices, sccs: Vec::<ListVerticesT>::default(),
        Tarjan{vertices: vertices.clone(), sccs: Vec::<ListVerticesT>::default(),  // TODO: remove clone()
            stack: ListVerticesT::default(), index: 0}
    }

    fn __init(&mut self, v: &VertexSP) {
        let mut _v = v.borrow_mut();
        _v.index = self.index;
        _v.low_link = self.index;
        _v.on_stack = true;
        self.stack.push(v.clone());
        self.index += 1;
    }

    fn __end(&mut self, v: &VertexSP) {
        let mut scc = ListVerticesT::new();
        let v = v.clone();
        let _v = v.borrow_mut();
        if _v.low_link == _v.index {
            //println!("{:?}", w.as_ref().unwrap());
            //w.as_ref().unwrap().as_ptr() != v.as_ptr()
            loop {
                println!("    t");
                let w = self.stack.pop().unwrap();
                let mut _w = w.borrow_mut();
                _w.low_link = _v.low_link;
                _w.on_stack = false;
                scc.push(w.clone());
                if w.as_ptr() == v.as_ptr() {
                    break;
                }
        }
        }
        if scc.len() > 1 {
            self.sccs.push(scc);
        }
    }

    pub fn recurse(&mut self, v: &VertexSP) {
        println!("recurse in");
        let v = v.clone();
        self.__init(&v);  // set up Vertex in scc discovery
        // Go through all children of this Vertex
        for w in &v.borrow_mut().children {
            let w2 = w.clone();
            let mut _w = w2.borrow_mut();
            let mut _v = v.borrow_mut();
            if _w.index == INDEX_NOT_SET {
                println!("   get into recurse");
                //self.recurse(w);
                _v.low_link = cmp::min(_v.low_link, _w.low_link);
            }

            else if _w.on_stack {
                println!("   not doing recurse");
                _v.low_link = cmp::min(_v.low_link, _w.index);
            }
        }
        println!("recurse out");
        self.__end(&v.clone());  // found scc
    }
}

fn calculate_sccs(vertices: &ListVerticesT) -> ListVerticesT
{
    let mut calc = Tarjan::new(vertices);
    for v in vertices {
        if v.borrow_mut().index == INDEX_NOT_SET {
            calc.recurse(v);
        }
    }
    return ListVerticesT::new()  // calc.sccs
}

pub fn getMaxVisitableWebpages(N: i32, M: i32, A: &Vec<i32>, B: &Vec<i32>) -> i32 {
    if A.is_empty() || B.is_empty() {
        return 0;
    }

    let mut edges = Vec::<Edge>::with_capacity(M as usize);
    for i in 0..M as usize {
        edges.push(Edge{ v: A[i] as IndexT, w: B[i] as IndexT });  // O(E)
    }

    //
    keep_uniques(&mut edges);  // O(E * log(E))
    let mut vertices = build_children(&edges);  // O(V + 2*E)
    let sccs = calculate_sccs(&vertices);  // O(V + E), calculate strongly connected components
    return 0;
}


type RetType = i32;

struct Args
{
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

pub fn tests() -> u32
{
    let wrapper = |p: &Args| -> RetType {
        let max_len = cmp::max(*p.A.iter().max().unwrap(), *p.B.iter().max().unwrap());
        return getMaxVisitableWebpages(max_len, p.A.len() as i32, &p.A, &p.B);
    };

    let args_list : Vec<Args> = vec![
        Args{ A: vec![ 1, 2, 3, 4 ], B: vec![ 4, 1, 2, 1 ], res: 4 },
        Args{ A: vec![ 3, 5, 3, 1, 3, 2 ], B: vec![ 2, 1, 2, 4, 5, 4 ], res: 4 },
        Args{ A: vec![ 3, 2, 5, 9, 10, 3, 3, 9, 4 ], B: vec![ 9, 5, 7, 8, 6, 4, 5, 3, 9 ], res: 5 },
        // extra1
        Args{ A: vec![ 3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 13, 14, 14     ], B: vec![ 9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  4,  4,  2     ], res: 8 },
        Args{ A: vec![ 3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 14, 15, 15     ], B: vec![ 9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  2,  4,  9     ], res: 8 },
        Args{ A: vec![ 3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 14, 13, 13, 13 ], B: vec![ 9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  2,  4,  5,  8 ], res: 8 },
        Args{ A: vec![ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6 ], B: vec![ 3, 4, 3, 4, 5, 6, 5, 6, 7, 8, 7, 8 ], res: 4 },
        Args{ A: vec![ 1, 3, 2 ], B: vec![ 3, 2, 3 ], res: 3 },
        Args{ A: vec![ 2, 1 ], B: vec![ 1, 2 ], res: 2 },
        Args{ A: vec![ 3, 5, 3, 1, 3, 2 ], B: vec![ 2, 2, 2, 4, 5, 4 ], res: 4 },
        Args{ A: vec![ 3, 5, 3, 1, 3, 2 ], B: vec![ 2, 2, 3, 4, 5, 4 ], res: 2 },
    ];

    return super::run_all_tests("l2_rabbit_hole1", args_list, wrapper, Option::None);
}
