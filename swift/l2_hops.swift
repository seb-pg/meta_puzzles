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

func getSecondsRequired(N: Int, F: Int, P: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=977526253003069
    // Constraints:
    //      2 ≤ N ≤ 10^12
    //      1 ≤ F ≤ 500,000
    //      1 ≤ Pi ≤ N−1
    // Complexity: O(N), but could be O(1) if P was sorted

    return N - P.prefix(F).min()!
}

// ---------------------------------------

struct TestArgsType {
    var N: Int
    var P: [Int]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(N: 3, P: [1]), 2),
            (TestArgsType(N: 6, P: [5, 2, 4]), 4),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getSecondsRequired(N: args.N, F: args.P.count, P: args.P) }
    return (wrapper, metaCases)
}
