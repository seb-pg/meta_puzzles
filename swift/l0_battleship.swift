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

func getHitProbability(R: Int, C: Int, G: [[Int]]) -> Double {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=3641006936004915
    // Constraints
    //      1 ≤ R,C ≤ 100       R,C is the number of rows,columns
    //      0 ≤ Gi,j ≤ 1
    // Complexity: O(N), where N=R*C

    let total = G.prefix(R).flatMap { $0.prefix(C) }.reduce(0, +) // alternative: let total = G.prefix(R).map { $0.prefix(C).reduce(0, +) }.reduce(0, +)
    return Double(total) / Double(R * C)  // Meta's code returns a Float
}

// ---------------------------------------

struct TestArgsType {
    var G: [[Int]]
}

typealias RetType = Double
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(G: [[0, 0, 1], [1, 0, 1]]), 0.5),
            (TestArgsType(G: [[1, 1], [1, 1]]), 1.0)
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(G: [[0, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0]]), 0.25)
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getHitProbability(R: args.G.count, C: args.G[0].count, G: args.G) }
    return (wrapper, metaCases + extra1Cases)
}
