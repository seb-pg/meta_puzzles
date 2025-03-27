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

func getArtisticPhotographCount(N: Int, C: String, X: Int, Y: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=870874083549040
    // Constraints
    //      1 ≤ N ≤ 200         N is the number of cells in a row
    //      1 ≤ X ≤ Y ≤ N       X,Y are the distance between a photograph and an actor
    // Complexity: O(N) ~ O(N * (Y-X+1)) because Y-X << N

    let w = Y - X + 1  // w = width of the interval
    let c = String(repeating: " ", count: Y) + C.prefix(N) + String(repeating: " ", count: Y)  // make our life easier by adding blank characters

    // calculation sub-intervals: O(N) ~ O(N * (Y-X+1))
    var possible: [(String, String)] = []
    for i in Y..<(N + Y) {
        if c[c.index(c.startIndex, offsetBy: i)] == "A" {
            let left = String(c[c.index(c.startIndex, offsetBy: i - Y)..<c.index(c.startIndex, offsetBy: i - Y + w)])
            let right = String(c[c.index(c.startIndex, offsetBy: i + X)..<c.index(c.startIndex, offsetBy: i + X + w)])
            possible.append((left, right))
        }
    }

    // Now count the possible combination of (P, B) on both sides of eligible positions: O(N) ~ O(N * (Y-X+1))
    var nb = 0
    for (left, right) in possible {
        nb += left.filter { $0 == "P" }.count * right.filter { $0 == "B" }.count
        nb += left.filter { $0 == "B" }.count * right.filter { $0 == "P" }.count
    }
    return nb
}

func tests() -> ( (String, Int, Int) -> Int, (String, Int, Int) -> (Int, String, Int, Int), [[(String, Int, Int), Int]]) {
    let fn: (String, Int, Int) -> (Int, String, Int, Int) = { C, X, Y in (C.count, C, X, Y) }
    let meta_cases: [(String, Int, Int), Int] = [
        (("APABA", 1, 2), 1),
        (("APABA", 2, 3), 0),
        ((".PBAAP.B", 1, 3), 3),
    ]
    let extra1_cases: [(String, Int, Int), Int] = [
        // (("PP.A.BB.B", 1, 3), 2),
    ]
    return (getArtisticPhotographCount, fn, [meta_cases, extra1_cases])
}
