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

func getMinimumDeflatedDiscCount(N: Int, R: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=183894130288005
    // Constraints
    //      1 ≤ N  ≤ 50                 N is the number of inflatable discs
    //      1 ≤ Ri ≤ 1,000,000,000      Ri is a disc radius
    // Complexity: O(N)

    var radiuses = Array(R.prefix(N))
    var nb = 0
    var currentRadius = radiuses.last!
    for nextRadius in radiuses.dropLast().reversed() {
        let targetRadius = currentRadius - 1
        if targetRadius <= 0 {
            return -1
        }
        nb += (targetRadius < nextRadius) ? 1 : 0
        currentRadius = min(nextRadius, targetRadius)
    }
    return nb
}

// ---------------------------------------

struct TestArgsType {
    var R: [Int]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(R: [2, 5, 3, 6, 5]), 3),
            (TestArgsType(R: [100, 100, 100]), 2),
            (TestArgsType(R: [6, 5, 4, 3]), -1),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMinimumDeflatedDiscCount(N: args.R.count, R: args.R) }
    return (wrapper, metaCases)
}
