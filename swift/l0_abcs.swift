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

// ---------------------------------------

struct TestArgsType {
    var A: Int
    var B: Int
    var C: Int
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(A: 1, B: 2, C: 3), 6),
            (TestArgsType(A: 100, B: 100, C: 100), 300),
            (TestArgsType(A: 85, B: 16, C: 93), 194),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getSum(A: args.A, B: args.B, C: args.C) }
    return (wrapper, metaCases)
}
