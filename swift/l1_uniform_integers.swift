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

// ---------------------------------------

struct TestArgsType {
    var A: Int
    var B: Int
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(A: 75, B: 300), 5),
            (TestArgsType(A: 1, B: 9), 9),
            (TestArgsType(A: 999999999999, B: 999999999999), 1),
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(A: 1, B: 1_000_000_000_000), 108),
        ])
    ]
    let extra2Cases: MetaCasesT = [
        ("extra2", [
            (TestArgsType(A: 10, B: 99), 9),
            (TestArgsType(A: 11, B: 98), 8),
            (TestArgsType(A: 21, B: 89), 7),
            (TestArgsType(A: 22, B: 88), 7),
            (TestArgsType(A: 23, B: 87), 5),
        ])
    ]
    let extra3Cases: MetaCasesT = [
        ("extra3", [
            (TestArgsType(A: 11, B: 88), 8),
            (TestArgsType(A: 11, B: 98), 8),
            (TestArgsType(A: 11, B: 99), 9),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getUniformIntegerCountInInterval(A: args.A, B: args.B) }
    return (wrapper, metaCases + extra1Cases + extra2Cases + extra3Cases)
}
