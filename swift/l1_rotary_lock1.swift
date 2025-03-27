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

func getMinCodeEntryTime(N: Int, M: Int, C: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=990060915068194
    // Constraints
    //      3 ≤ N ≤ 50,000,000      N is the number of integers
    //      1 ≤ M ≤ 1,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M)

    var pos = 1
    var nb = 0
    for target in C.prefix(M) {
        // codeconvert generating this (error with negative modulo)
        //let positiveMove = (target - pos) % N
        // the following correct was added manually
        var positiveMove = (target - pos) % N
		if (positiveMove) < 0 {
			positiveMove += N
		}
        // codeconvert: the rest is correct
        let negativeMove = N - positiveMove
        nb += min(positiveMove, negativeMove)
        pos = target
    }
    return nb
}

func tests() -> (getMinCodeEntryTime: (Int, Int, [Int]) -> Int, fn: (Int, [Int]) -> (Int, Int, [Int]), metaCases: [(String, [(Int, [Int], Int)])]) {
    let fn: (Int, [Int]) -> (Int, Int, [Int]) = { N, C in (N, C.count, C) }
    let metaCases: [(String, [(Int, [Int], Int)])] = [
        ("meta", [ (3, [1, 2, 3], 2), (10, [9, 4, 4, 8], 11) ])
    ]
    return (getMinCodeEntryTime, fn, metaCases)
}
