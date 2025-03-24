// This was converted from Python to Javascript using https://www.codeconvert.ai/

class Vertex {
    constructor(nb) {
        this.nb = nb;
        this.inputs = 0;
        this.level = 1;
        this.in_cycle = true;
        this.cycle_len = 0;
        this.next = null;
    }

    toString() {
        return `Vertex(i=${this.nb}, inputs=${this.inputs}, in_cycle=${this.in_cycle}, cycle_len=${this.cycle_len}, level=${this.level}, next=${this.next ? this.next.nb : -1})`;
    }
}

function getMaxVisitableWebpages(N, L) {
    const vertices = Array.from({ length: N }, (_, i) => new Vertex(i + 1));

    for (let i = 0; i < N; i++) {
        const vertex = vertices[i];
        const n = L[i];
        vertex.next = vertices[n - 1];
        vertex.next.inputs += 1;
    }

    const entrance_vertices = vertices.filter(vertex => vertex.inputs === 0);

    let visited_vertices = [...entrance_vertices];
    while (visited_vertices.length > 0) {
        const curr_vertex = visited_vertices.pop();
        curr_vertex.in_cycle = false;
        const next_vertex = curr_vertex.next;
        next_vertex.level = Math.max(next_vertex.level, curr_vertex.level + 1);
        next_vertex.inputs -= 1;
        if (next_vertex.inputs === 0) {
            visited_vertices.push(next_vertex);
        }
    }

    for (const vertex of vertices) {
        if (!vertex.in_cycle || vertex.cycle_len > 0) {
            continue;
        }
        let cycle_len = 1;
        let curr = vertex.next;
        while (curr !== vertex) {
            cycle_len += 1;
            curr = curr.next;
        }
        vertex.cycle_len = cycle_len;
        curr = vertex.next;
        while (curr !== vertex) {
            curr.cycle_len = cycle_len;
            curr = curr.next;
        }
    }

    let max_chain = 0;
    for (const vertex of vertices) {
        if (vertex.in_cycle) {
            max_chain = Math.max(max_chain, vertex.cycle_len);
        } else if (vertex.next.in_cycle) {
            max_chain = Math.max(max_chain, vertex.level + vertex.next.cycle_len);
        }
    }
    return max_chain;
}

function tests() {
    const fn = (L) => [L.length, L];
    const meta_cases = ["meta", [
        [[[4, 1, 2, 1]], 4],
        [[[4, 3, 5, 1, 2]], 3],
        [[[2, 4, 2, 2, 3]], 4],
    ]];
    const extra1_cases = ["extra1", [
        [[[1]], 1],
        [[[1, 2]], 1],
        [[[2, 1]], 2],
        [[[3, 3, 4, 3]], 3],
        [[[4, 5, 6, 5, 6, 4]], 4],
        [[[6, 5, 4, 5, 6, 4]], 4],
        [[[3, 3, 4, 1]], 4],
        [[[2, 3, 2]], 3],
        [[[2, 4, 2, 2, 3]], 4],
        [[[6, 5, 4, 3, 2, 1]], 2],
    ]];
    const extra2_cases = ["extra2", [
        [[[4, 1, 2, 1]], 4],
        [[[4, 3, 5, 1, 2]], 3],
        [[[4, 1, 2, 1]], 4],
        [[[2, 1, 4, 3]], 2],
        [[[2, 4, 2, 2, 4, 5]], 4],
        [[[4, 1, 2, 1]], 4],
        [[[4, 3, 5, 1, 2]], 3],
        [[[2, 4, 2, 2, 4]], 3],
        [[[2, 3, 4, 2, 2, 3, 6, 9, 8]], 5],
    ]];
    const cycles = [8, 9, 10, 11, 12, 7];
    const extra3_cases = ["extra3", [
        [[[2, 4, 2, 2, 3, 4].concat(cycles)], 6],
        [[[2, 4, 2, 2, 4, 5].concat(cycles)], 6],
    ]];
    return [getMaxVisitableWebpages, fn, [meta_cases, extra1_cases, extra2_cases, extra3_cases]];
}

module.exports = {tests};
