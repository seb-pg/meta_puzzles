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
    var inputs: Int = 0
    var level: Int = 1
    var inCycle: Bool = true
    var cycleLen: Int = 0
    var next: Vertex?

    init(nb: Int) {
        self.nb = nb
    }

    var description: String {
        return "Vertex(i=\(nb), inputs=\(inputs), in_cycle=\(inCycle), cycle_len=\(cycleLen), level=\(level), next=\(next?.nb ?? -1))"
    }
}

func getMaxVisitableWebpages(N: Int, L: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=316794079975021
    // Constraints:
    //      2 ≤ N ≤ 500,000
    //      1 ≤ Li ≤ N
    //      Li ≠ i
    //  Complexity: O(N)

    var vertices = (1...N).map { Vertex(nb: $0) }

    for (i, n) in L.enumerated() {
        let vertex = vertices[i]
        let nextVertex = vertices[n - 1]
        vertex.next = nextVertex
        nextVertex.inputs += 1
    }

    var entranceVertices = vertices.filter { $0.inputs == 0 }

    var visitedVertices = entranceVertices
    while !visitedVertices.isEmpty {
        let currVertex = visitedVertices.removeLast()
        currVertex.inCycle = false
        if let nextVertex = currVertex.next {
            nextVertex.level = max(nextVertex.level, currVertex.level + 1)
            nextVertex.inputs -= 1
            if nextVertex.inputs == 0 {
                visitedVertices.append(nextVertex)
            }
        }
    }

    for vertex in vertices {
        if !vertex.inCycle || vertex.cycleLen > 0 {
            continue
        }
        var cycleLen = 1
        var curr = vertex.next
        while curr !== vertex {
            cycleLen += 1
            curr = curr?.next
        }
        vertex.cycleLen = cycleLen
        curr = vertex.next
        while curr !== vertex {
            curr?.cycleLen = cycleLen
            curr = curr?.next
        }
    }

    var maxChain = 0
    for vertex in vertices {
        if vertex.inCycle {
            maxChain = max(maxChain, vertex.cycleLen)
        } else if let nextVertex = vertex.next, nextVertex.inCycle {
            maxChain = max(maxChain, vertex.level + nextVertex.cycleLen)
        }
    }
    return maxChain
}

func tests() -> ( (Int, [Int]) -> Int, ([(Int, [Int])]) -> (Int, [Int]) ) {
    let fn: (Int, [Int]) -> Int = { getMaxVisitableWebpages(N: $0, L: $1) }
    let metaCases = [
        (([4, 1, 2, 1], ), 4),
        (([4, 3, 5, 1, 2], ), 3),
        (([2, 4, 2, 2, 3], ), 4),
    ]
    let extra1Cases = [
        (([1], ), 1),
        (([1, 2], ), 1),
        (([2, 1], ), 2),
        (([3, 3, 4, 3], ), 3),
        (([4, 5, 6, 5, 6, 4], ), 4),
        (([6, 5, 4, 5, 6, 4], ), 4),
        (([3, 3, 4, 1], ), 4),
        (([2, 3, 2], ), 3),
        (([2, 4, 2, 2, 3], ), 4),
        (([6, 5, 4, 3, 2, 1], ), 2),
    ]
    let extra2Cases = [
        (([4, 1, 2, 1], ), 4),
        (([4, 3, 5, 1, 2], ), 3),
        (([4, 1, 2, 1], ), 4),
        (([2, 1, 4, 3], ), 2),
        (([2, 4, 2, 2, 4, 5], ), 4),
        (([4, 1, 2, 1], ), 4),
        (([4, 3, 5, 1, 2], ), 3),
        (([2, 4, 2, 2, 4], ), 3),
        (([2, 3, 4, 2, 2, 3, 6, 9, 8], ), 5),
    ]
    let cycles = [8, 9, 10, 11, 12, 7]
    let extra3Cases = [
        (([2, 4, 2, 2, 3, 4] + cycles, ), 6),
        (([2, 4, 2, 2, 4, 5] + cycles, ), 6),
    ]
    return (fn, [metaCases, extra1Cases, extra2Cases, extra3Cases])
}
