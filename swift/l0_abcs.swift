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

func getSum(A: Int, B: Int, C: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=513411323351554
    // Constraints
    //   1 ≤ A,B,C ≤ 100
    // Complexity: O(1)

    return A + B + C
}

func tests() -> (getSum: (Int, Int, Int) -> Int, fn: (Int, Int, Int) -> (Int, Int, Int), metaCases: [(String, [(Int, Int, Int, Int)])]) {
    let fn: (Int, Int, Int) -> (Int, Int, Int) = { a, b, c in (a, b, c) }
    let metaCases: [(String, [(Int, Int, Int, Int)])] = [
        ("meta", [ (1, 2, 3, 6), (100, 100, 100, 300), (85, 16, 93, 194) ])
    ]
    return (getSum, fn, metaCases)
}
