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

struct Counts {
    var p: Int
    var b: Int
}

func getArtisticPhotographCount(N: Int, C: String, X: Int, Y: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=156565259776376
    // Constraints
    //      1 ≤ N ≤ 200         N is the number of cells in a row
    //      1 ≤ X ≤ Y ≤ N       X,Y are the distance between a photograph and an actor
    // Complexity: O(N) ~ O(N * (Y-X+1)) because Y-X << N

    var C = String(C.prefix(N))

    let w = Y + 1
    var countP = 0, countB = 0
    var counts = Array(repeating: Counts(p: 0, b: 0), count: w)
    
    for ci in C {
        if ci == "P" {
            countP += 1
        } else if ci == "B" {
            countB += 1
        }
        counts.append(Counts(p: countP, b: countB))
    }
    counts.append(contentsOf: Array(repeating: counts.last!, count: w))

    let possible = C.enumerated().compactMap { (index, ci) in ci == "A" ? index + w : nil }

    let nb1 = possible.reduce(0) { (result, i) in
        result + (counts[i - X].p - counts[i - Y - 1].p) * (counts[i + Y].b - counts[i + X - 1].b)
    }

    let nb2 = possible.reduce(0) { (result, i) in
        result + (counts[i - X].b - counts[i - Y - 1].b) * (counts[i + Y].p - counts[i + X - 1].p)
    }
    
    return nb1 + nb2
}

func tests() -> (getArtisticPhotographCount: (Int, String, Int, Int) -> Int, fn: (String, Int, Int) -> (Int, String, Int, Int), cases: [(String, [(String, Int)])]) {
    let fn: (String, Int, Int) -> (Int, String, Int, Int) = { C, X, Y in (C.count, C, X, Y) }
    let metaCases = "meta", [
        (("APABA", 1, 2), 1),
        (("APABA", 2, 3), 0),
        ((".PBAAP.B", 1, 3), 3),
    ]
    let extra1Cases = "extra1", [
        (("PP.A.BB.B", 1, 3), 4),
    ]
    return (getArtisticPhotographCount, fn, [metaCases, extra1Cases])
}

