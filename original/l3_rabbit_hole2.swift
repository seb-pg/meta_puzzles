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

// This was converted from Python to Javascript using https://www.codeconvert.ai/free-converter

import Foundation

class Vertex {
    var nb: Int
    var weight: Int = 0  // 0 means unused
    var children: [Vertex] = []
    
    // members for strongly connected components
    var index: Int = -1
    var lowLink: Int = -1
    var onStack: Bool = false
    
    // members for dag construction
    var target: Vertex? = nil  // target node
    
    // members for max length calculation
    var inputs: Int = 0  // number of inputs for a given node
    var maxLen: Int = 0  // used for memoization of max_len at node level
    
    init(nb: Int) {
        self.nb = nb
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nb)
    }
    
    var description: String {
        return "Vertex(nb=\(nb), weight=\(weight), inputs=\(inputs), index=\(index), lowLink=\(lowLink), children=\(children.map { $0.nb }))"
    }
}

func keepUnique(edges: inout [(Int, Int)]) {  // O(E*log(E))
    if edges.count > 1 {
        edges.sort { $0.0 < $1.0 }
        var i = 1
        for (e1, e2) in zip(edges, edges.dropFirst()) {
            if e1 != e2 {
                edges[i] = e2
                i += 1
            }
        }
        edges = Array(edges.prefix(i))
    }
}

func buildChildren(edges: [(Int, Int)]) -> [Vertex] {  // O(V + E)
    let nbVertices = edges.flatMap { [$0.0, $0.1] }.max() ?? 0  // O(2*E), we do not count it
    var vertices = (0...nbVertices).map { Vertex(nb: $0) }  // O(V)
    for (v, w) in edges {  // O(E)
        vertices[v].children.append(vertices[w])
        vertices[v].weight = 1
        vertices[w].weight = 1
    }
    return vertices
}

class Tarjan {
    var vertices: [Vertex]
    var sccs: [[Vertex]] = []
    var stack: [Vertex] = []
    var index: Int = 0
    
    init(vertices: [Vertex]) {
        self.vertices = vertices
    }
    
    private func initVertex(_ v: Vertex) {
        v.index = index
        v.lowLink = index
        v.onStack = true
        stack.append(v)
        index += 1
    }
    
    private func endVertex(_ v: Vertex) {
        var scc: [Vertex] = []
        if v.lowLink == v.index {
            var w: Vertex?
            repeat {
                w = stack.removeLast()
                w?.lowLink = v.lowLink
                w?.onStack = false
                scc.append(w!)
            } while w !== v
        }
        if scc.count > 1 {
            sccs.append(scc)
        }
    }
    
    func recurse(_ v: Vertex) {
        initVertex(v)  // set up vertex in scc discovery
        // Go through all children of this vertex
        for w in v.children {
            if w.index == -1 {  // not visited
                recurse(w)
                v.lowLink = min(v.lowLink, w.lowLink)
            } else if w.onStack {
                v.lowLink = min(v.lowLink, w.index)
            }
        }
        endVertex(v)  // found scc
    }
}

func calculateSCCs(vertices: [Vertex], iterative: Bool) -> [[Vertex]] {
    let calc = Tarjan(vertices: vertices)
    let fn = calc.recurse
    for v in calc.vertices {
        if v.index == -1 {
            fn(v: v)
        }
    }
    return calc.sccs
}

func makeDAG(vertices: [Vertex], sccs: [[Vertex]]) {
    // merge vertices in each scc
    for scc in sccs {
        let v = scc[0]  // target node (first node in scc)
        v.weight = scc.count  // update the weight of the vertex
        v.children = scc.flatMap { $0.children.filter { v.lowLink != $0.lowLink } }
        for w in scc {
            if ObjectIdentifier(w) != ObjectIdentifier(v) {
                w.target = v  // used for children remapping
                w.weight = 0  // indicates the vertex is not used anymore
            }
        }
    }
    
    // remap children to the target node (if applicable)
    for v in vertices {
        if !v.children.isEmpty {
            v.children = v.children.map { $0.target ?? $0 }
            v.children = Array(Set(v.children))  // remove duplicates
        }
    }
}

func dagMaxLen(vertices: [Vertex], iterative: Bool) -> Int {
    func recurse(v: Vertex) -> Int {
        var maxLen = 0
        for w in v.children {
            let currLen: Int
            if w.maxLen == 0 && ObjectIdentifier(v) != ObjectIdentifier(w) {
                currLen = recurse(v: w)
            } else {
                currLen = w.maxLen
            }
            maxLen = max(maxLen, currLen)
        }
        v.maxLen = v.weight + maxLen
        return v.maxLen
    }
    
    // calculate the number of inputs for each vertex
    for v in vertices {
        if v.weight > 0 {
            for w in v.children {
                if ObjectIdentifier(v) != ObjectIdentifier(w) {
                    w.inputs += 1
                }
            }
        }
    }
    
    return vertices.filter { $0.weight > 0 && $0.inputs == 0 }.map { recurse(v: $0) }.max() ?? 0
}

func getMaxVisitableWebpages(N: Int, M: Int, A: [Int], B: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=254501763097320
    // Constraints :
    //      2 ≤ N ≤ 500,000   N different web pages
    //      1 ≤ M ≤ 500,000   M links present across the pages
    //      1 ≤ Ai, Bi ≤ N    ith of which is present on page Ai and links to a different page Bi
    //      Ai ≠ Bi           a page cannot link to itself
    //      Complexity: O(V + E * log(E))  because of call to keep_unique()

    let iterative = false  // iterative SCC is too slow to pass tests (almost expected and sad)
    if !iterative {
        // Set recursion limit if needed
    }
    
    let A = Array(A.prefix(M))
    let B = Array(B.prefix(M))
    let edges = Array(zip(A, B))  // O(E)
    let uniqueEdges = keepUnique(edges: edges)  // O(E*log(E))
    let vertices = buildChildren(edges: uniqueEdges)  // O(V + 2*E)
    let sccs = calculateSCCs(vertices: vertices, iterative: iterative)  // O(V + E), calculate strongly connected components
    makeDAG(vertices: vertices, sccs: sccs)  // O(V + E)
    let res = dagMaxLen(vertices: vertices, iterative: iterative)  // O(V + E)
    return res
}
