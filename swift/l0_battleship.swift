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

func tests() -> (getHitProbability: (Int, Int, [[Int]]) -> Double, fn: ([[Int]]) -> (Int, Int, [[Int]]), metaCases: [(String, [( [[Int]], Double)])], extraCases: [(String, [( [[Int]], Double)])]) {
    let fn: ([[Int]]) -> (Int, Int, [[Int]]) = { G in (G.count, G[0].count, G) }
    let metaCases: [(String, [( [[Int]], Double)])] = [
        ("meta", [([[0, 0, 1], [1, 0, 1]], 0.5), ([[1, 1], [1, 1]], 1.0)])
    ]
    let extra1Cases: [(String, [( [[Int]], Double)])] = [
        ("extra1", [([[0, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0]], 0.25)])
    ]
    return (getHitProbability, fn, metaCases, extra1Cases)
}

