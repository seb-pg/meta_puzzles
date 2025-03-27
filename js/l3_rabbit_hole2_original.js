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

// This was partially converted from Python to Javascript using https://www.codeconvert.ai/
// some of the code was adapted by hand, and the result produces many errors on Meta's website
//     Runtime Error on 8 test cases
//     Time Limit Exceeded on 1 test case

class Vertex {
    constructor(nb, weight = 0) {
        this.nb = nb;
        this.weight = weight; // 0 means unused
        this.children = []; // default empty array

        // members for strongly connected components
        this.index = -1;
        this.low_link = -1;
        this.on_stack = false;

        // members for dag construction
        this.target = null; // target node

        // members for max length calculation
        this.inputs = 0; // number of inputs for a given node
        this.max_len = 0; // used for memoization of max_len at node level
    }

    toString() {
        return `Vertex(nb=${this.nb}, weight=${this.weight}, inputs=${this.inputs}, index=${this.index}, low_link=${this.low_link}, children=[${this.children.map(v => v.nb).join(', ')}])`;
    }
}

/*function* zip(arr1, arr2) {
    for (let i = 0; i < Math.min(arr1.length, arr2.length); i++) {
        yield [arr1[i], arr2[i]];
    }
}*/

function keepUnique(edges) { // O(E*log(E))
    if (edges.length > 1) {
        /*edges.sort();
        let i = 1;
        for (let [e1, e2] of zip(edges, edges.slice(1))) {
            if (e1 !== e2) {
                edges[i] = e2;
                i++;
            }
        }
        edges = edges.slice(0, i);*/
        return edges.sort().filter(function(item, pos, _array) {
            return pos == 0 || item != _array[pos - 1];
        });
    }
    return edges;
}

function buildChildren(edges) { // O(V + E)
    // Note: codeconvert uses flat() but Meta's website generates "TypeError: edges.flat is not a function"
    const nbVertices = Math.max(...edges.map(v => Math.max(...v))); // O(2*E), we do not count it
    const vertices = Array.from({ length: nbVertices + 1 }, (_, i) => new Vertex(i)); // O(V)
    for (let [v, w] of edges) { // O(E)
        vertices[v].children.push(vertices[w]);
        vertices[v].weight = 1;
        vertices[w].weight = 1;
    }
    return vertices;
}

class Tarjan {
    constructor(vertices) {
        this.vertices = vertices;
        this.sccs = [];
        this.stack = [];
        this.index = 0;
    }

    init(v) {
        v.index = this.index;
        v.low_link = this.index;
        v.on_stack = true;
        this.stack.push(v);
        this.index++;
    }

    end(v) {
        const scc = [];
        if (v.low_link === v.index) {
            let w = null;
            while (w !== v) {
                w = this.stack.pop();
                w.low_link = v.low_link;
                w.on_stack = false;
                scc.push(w);
            }
        }
        if (scc.length > 1) {
            this.sccs.push(scc);
        }
    }

    recurse(v) {
        this.init(v); // set up vertex in scc discovery
        // Go through all children of this vertex
        for (let w of v.children) {
            if (w.index === -1) { // not visited
                this.recurse(w);
                v.low_link = Math.min(v.low_link, w.low_link);
            } else if (w.on_stack) {
                v.low_link = Math.min(v.low_link, w.index);
            }
        }
        this.end(v); // found scc
    }
}

function calculateSCCs(vertices, iterative) { // Tarjan's algorithm
    const calc = new Tarjan(vertices);
    const fn = calc.recurse.bind(calc);
    for (let v of calc.vertices) {
        if (v.index === -1) {
            fn(v);
        }
    }
    return calc.sccs;
}

function makeDAG(vertices, sccs) { // O(V + E)
    // merge vertices in each scc
    for (let scc of sccs) { // O(V)
        const v = scc[0]; // target node (first node in scc)
        v.weight = scc.length; // update the weight of the vertex
        v.children = [].concat(...scc.map(w => w.children.filter(x => v.low_link !== x.low_link)));
        for (let w of scc) {
            if (w !== v) {
                w.target = v; // used for children remapping
                w.weight = 0; // indicates the vertex is not used anymore
            }
        }
    }

    // remap children to the target node (if applicable)
    for (let v of vertices) { // O(V + E)
        if (v.children.length) {
            v.children = v.children.map(w => w.target || w);
            v.children = Array.from(new Set(v.children));
        }
    }
}

function dagMaxLen(vertices, iterative) {  // O(V + E)

    function recurse(v) {
        let max_len = 0;
        for (const w of v.children) {
            if (w.max_len === 0 && v !== w) {
                curr_len = recurse(w);
            } else {
                curr_len = w.max_len;
            }
            max_len = Math.max(max_len, curr_len);
        }
        v.max_len = v.weight + max_len;
        return v.max_len;
    }

    // calculate the number of inputs for each vertex
    for (const v of vertices) {  // O(V + E)
        if (v.weight > 0) {
            for (const w of v.children) {
                if (v !== w) {
                    w.inputs += 1;
                }
            }
        }
    }

    return Math.max(...vertices.filter(v => v.weight && v.inputs === 0).map(v => recurse(v)));
}

function getMaxVisitableWebpages(N, M, A, B) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=254501763097320
    // Constraints :
    //      2 ≤ N ≤ 500,000   N different web pages
    //      1 ≤ M ≤ 500,000   M links present across the pages
    //      1 ≤ Ai, Bi ≤ N    ith of which is present on page Aiand links to a different page Bi
    //      Ai ≠ Bi           a page cannot link to itself
    //      Complexity: O(V + E * log(E))  because of call to keep_unique()

    let iterative = false;  // iterative SCC is too slow to pass tests (almost expected and sad)
    if (!iterative) {
        // No direct equivalent for sys.setrecursionlimit in JavaScript
    }

    A = A.slice(0, M);
    B = B.slice(0, M);  // Just in case
    edges = A.map((a, i) => [a, B[i]]);  // O(E)  [note: codeconvert declare "const edges"]
    edges = keepUnique(edges);  // O(E*log(E))
    const vertices = buildChildren(edges);  // O(V + 2*E)
    const sccs = calculateSCCs(vertices, iterative);  // O(V + E), calculate strongly connected components
    makeDAG(vertices, sccs);  // O(V + E)
    const res = dagMaxLen(vertices, iterative);  // O(V + E)
    return res;
}

function tests() {
    function fn(A, B) {
        return [Math.max(Math.max(...A), Math.max(...B)), A.length, A, B];
    }

    const metaCases = ["meta", [
        //[[[1, 2, 3, 4], [4, 1, 2, 1]], 4],
        //[[[3, 5, 3, 1, 3, 2], [2, 1, 2, 4, 5, 4]], 4],
        //[[[3, 2, 5, 9, 10, 3, 3, 9, 4], [9, 5, 7, 8, 6, 4, 5, 3, 9]], 5],
    ]];
    const extra1Cases = ["extra1", [
        //[[[3, 2, 5, 9, 10, 3, 3, 9, 4, 9, 11, 12, 13, 14, 14],
        //  [9, 5, 7, 8, 6, 4, 5, 3, 9, 11, 12, 9, 4, 4, 2]], 8],
        //[[[3, 2, 5, 9, 10, 3, 3, 9, 4, 9, 11, 12, 14, 15, 15],
        //  [9, 5, 7, 8, 6, 4, 5, 3, 9, 11, 12, 9, 2, 4, 9]], 8],
        [[[3, 2, 5, 9, 10, 3, 3, 9, 4, 9, 11, 12, 14, 13, 13, 13],
          [9, 5, 7, 8, 6, 4, 5, 3, 9, 11, 12, 9, 2, 4, 5, 8]], 8],
        //[[[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6], [3, 4, 3, 4, 5, 6, 5, 6, 7, 8, 7, 8]], 4],
        //[[[1, 3, 2], [3, 2, 3]], 3],
        //[[[2, 1], [1, 2]], 2],
        //[[[3, 5, 3, 1, 3, 2], [2, 2, 2, 4, 5, 4]], 4],
        //[[[3, 5, 3, 1, 3, 2], [2, 2, 5, 4, 5, 4]], 4],  // 3 is referencing 5 twice
        //[[[3, 5, 3, 1, 3, 2], [2, 2, 3, 4, 5, 4]], 4],  // 3 is self referencing
    ]];
    return [getMaxVisitableWebpages, fn, [metaCases, extra1Cases]];
}

module.exports = {tests};
