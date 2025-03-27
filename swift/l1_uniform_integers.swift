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

func getUniformIntegerCountInInterval(A: Int, B: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=228269118726856
    // Constraints:
    //      1 ≤ A ≤ B ≤ 10^12
    // Complexity: O(log(max(A, B)))
    //      logarithmic on the number of digits to represent the integers
    //      The python version works using integer<->string conversion, which is not great

    let lenA = String(A).count
    let lenB = String(B).count
    let tmpA = Int(String(repeating: "1", count: lenA))!
    let tmpB = Int(String(repeating: "1", count: lenB))!

    let nbA = (tmpA * 10 - A) / tmpA
    let nbB = B / tmpB
    let nbM = (lenB - lenA >= 2) ? 9 * (lenB - lenA - 1) : 0
    var nb = nbA + nbM + nbB

    if lenA == lenB {
        nb -= 9
    }
    return nb
}

func tests() -> (getUniformIntegerCountInInterval: (Int, Int) -> Int, fn: (Int, Int) -> (Int, Int), metaCases: [(String, [(Int, Int)])]) {
    func fn(A: Int, B: Int) -> (Int, Int) { return (A, B) }
    let metaCases: [(String, [(Int, Int)])] = [
        ("meta", [((75, 300), 5),
                  ((1, 9), 9),
                  ((999999999999, 999999999999), 1)]),
        ("extra1", [((1, 1_000_000_000_000), 108)]),
        ("extra2", [((10, 99), 9),
                    ((11, 98), 8),
                    ((21, 89), 7),
                    ((22, 88), 7),
                    ((23, 87), 5)]),
        ("extra3", [((11, 88), 8),
                    ((11, 98), 8),
                    ((11, 99), 9)])
    ]
    return (getUniformIntegerCountInInterval, fn, metaCases)
}
