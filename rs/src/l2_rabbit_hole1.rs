#![allow(non_snake_case)]

use std::rc::Rc;
use std::cell::RefCell;

#[derive(Clone)]
struct Vertex {
    nb: usize,
    inputs: u32,
    level: u32,
    in_cycle: bool,
    cycle_len: u32,
    next: Option<VertexSP>,
}

impl Vertex {
    fn new(nb: usize) -> Vertex {
        Vertex{ nb, inputs: 0,  level: 1, in_cycle: true, cycle_len:  0, next: Option::None }
    }
}

type VertexSP = Rc<RefCell<Vertex>>;
type ListVerticesT = Vec<VertexSP>;

pub fn getMaxVisitableWebpages(N: i32, L: &Vec<i32>) -> i32 {
    use std::cmp;

    let _N = N as usize;

    let mut vertices: ListVerticesT = Vec::with_capacity(_N);
    for i in 0.._N {
        vertices.push(Rc::new(RefCell::new(Vertex::new(i + 1))));
    }

    // count the number of inputs for each vertex, and set next vertex: O(N)
    for i in 0.._N {
        //let next_vertex = &vertices[static_cast<uint32_t>(L[i]) - 1];
        let next_vertex = &vertices[L[i] as usize - 1];
        next_vertex.borrow_mut().inputs += 1;
        let vertex = &vertices[i];
        vertex.borrow_mut().next = Option::Some(next_vertex.clone());  // yes, we could use indices or raw pointers (as "vertices" is never resized)
    }

    // find the entrance vertices (could be []): O(N)
    let mut entrance_vertices = ListVerticesT::with_capacity(_N);
    for vertex in &vertices {
        if vertex.borrow_mut().inputs == 0 {
            entrance_vertices.push(vertex.clone());
        }
    }

    // calculate "level" of each vertex that is not in a cycle: O(N)
    while !entrance_vertices.is_empty() {
        let _curr_vertex = entrance_vertices.pop().unwrap();
        let mut curr_vertex = _curr_vertex.borrow_mut();
        curr_vertex.in_cycle = false;
        let mut _next_vertex = curr_vertex.next.as_ref().unwrap();
        let mut next_vertex = _next_vertex.borrow_mut();
        next_vertex.level = cmp::max(next_vertex.level, curr_vertex.level + 1);
        next_vertex.inputs -= 1;
        if next_vertex.inputs == 0 {
            entrance_vertices.push(_curr_vertex);
        }
    }

    // calculate length of cycles of the different cycle: O(N)
    for vertex in &vertices {
    }

    // Now calculate the maximum length: O(N)

    //return max_chain as i32;
    return -1;
}

// TODO: uses smart pointers
