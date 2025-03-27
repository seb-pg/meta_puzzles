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

// This was converted from Python to Javascript using https://www.codeconvert.ai/
// Conversion did not work immediately (G.map((row, j))
// Then
//      You solved 16 / 31 test cases.
//      Wrong Answer on 15 test cases

class NodeInfo {
    constructor(row, col, nodeType, distance = Number.MAX_SAFE_INTEGER, source = null) {
        this.row = row;
        this.col = col;
        this.nodeType = nodeType;
        this.distance = distance; // cost of the cheapest path from start to n currently known
        this.source = source; // previous node with cheapest path
    }

    debugReconstructPath() {
        let node = this;
        const path = [];
        while (node) {
            path.push(node);
            node = node.source;
        }
        return path.reverse().map(n => [n.col, n.row, n.distance]);
    }
}

function addNeighbour(q, h, d, node, neighbour) {
    const neighborDistance = d(node, neighbour);
    if (neighborDistance >= neighbour.distance) {
        return;
    }
    if (neighbour.source === null) {
        q.push({ score: h(neighbour), node: neighbour });
    }
    neighbour.source = node;
    neighbour.distance = neighborDistance;
}

function getSecondsRequired(R, C, G) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=544961100246576
    // Constraints:
    //      1 ≤ R,C ≤ 50
    //      Gi,j ∈ {".", "S", "E", "#", "a"..."z"}
    // Complexity: see A* search algorithm (https://en.wikipedia.org/wiki/A*_search_algorithm)

    // codeconvert does not "map" correctly string
    //const grid = G.map((row, j) => row.map((elt, i) => new NodeInfo(j, i, elt)));
    const grid = G.map((row, j) => Array.from(row).map((elt, i) => new NodeInfo(j, i, elt)));
    const portals = {};

    let start = [0, 0];
    const ends = [];
    for (let j = 0; j < G.length; j++) {
        for (let i = 0; i < G[j].length; i++) {
            const nodeType = G[j][i];
            if (nodeType === 'S') {
                start = [j, i];
            } else if (nodeType === 'E') {
                ends.push([j, i]); // Ends could be used for a heuristic
            } else if (nodeType >= 'a' && nodeType <= 'z') {
                if (!portals[nodeType]) portals[nodeType] = [];
                portals[nodeType].push(grid[j][i]);
            }
        }
    }
    const startNode = grid[start[0]][start[1]];
    startNode.distance = 0;

    // codeconvert uses a list, sorted multiple type as javascript does not have a min or max heap
    const q = []; // contains { score, node }
    const h = n => n.distance; // heuristic is the node distance (very basic)
    const d = (n1, n2) => n1.distance + 1; // distance is always one

    const neighboursDirections = [[-1, 0], [1, 0], [0, -1], [0, 1]];

    q.push({ score: h(startNode), node: startNode });
    while (q.length) {
        // codeconvert did not pick up NodeInfo.__lt__ in the Python source
        //q.sort((a, b) => a.score - b.score);  // codeconvert: You solved 16 / 31 test cases.
        q.sort((a, b) => (a.score - b.score, a.node.distance - b.node.distance));
        const { score, node } = q.shift();
        if (node.nodeType === 'E') {
            return node.distance;
        }
        // add portal nodes to node
        if (node.nodeType >= 'a' && node.nodeType <= 'z') {
            for (const neighbour of portals[node.nodeType]) {
                if (neighbour !== node) {
                    addNeighbour(q, h, d, node, neighbour);
                }
            }
        }
        // add neighbours to node
        const neighboursCoords = neighboursDirections.map(([drow, dcol]) => [node.row + drow, node.col + dcol]);
        const neighbours = neighboursCoords
            .filter(([row, col]) => (0 <= row && row < R) && (0 <= col && col < C))
            .map(([row, col]) => grid[row][col]);
        for (const neighbour of neighbours) {
            if (neighbour.nodeType !== '#') {
                addNeighbour(q, h, d, node, neighbour);
            }
        }
    }
    return -1;
}

function tests() {
    const fn = G => [G.length, G[0].length, G];
    const metaCases = ["meta", [
        [[[".E.", ".#E", ".S#"]], 4],
        [[["a.Sa", "####", "Eb.b"]], -1],
        [[["aS.b", "####", "Eb.a"]], 4],
        [[["xS..x..Ex"]], 3],
    ]];
    return [getSecondsRequired, fn, [metaCases]];
}

module.exports = {tests};
