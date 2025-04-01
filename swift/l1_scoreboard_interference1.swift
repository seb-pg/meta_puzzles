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

func getMinProblemCount(N: Int, S: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=348371419980095
    // Constraints
    //      1 ≤ N ≤ 500,000             N is the number of scores
    //      1 ≤ Si ≤ 1,000,000,000      Si is a score
    // Complexity: O(N)

    var minNumberOfTwos = 0
    var minNumberOfOnes = 0
    for score in S.prefix(N) {
        let numberOfTwos = score / 2
        let numberOfOnes = score % 2
        minNumberOfTwos = max(minNumberOfTwos, numberOfTwos)
        minNumberOfOnes = max(minNumberOfOnes, numberOfOnes)
    }
    return minNumberOfTwos + minNumberOfOnes
}

// ---------------------------------------

struct TestArgsType {
    var S: [Int]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(S: [1, 2, 3, 4, 5, 6]), 4),
            (TestArgsType(S: [4, 3, 3, 4]), 3),
            (TestArgsType(S: [2, 4, 6, 8]), 4),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMinProblemCount(N: args.S.count, S: args.S) }
    return (wrapper, metaCases)
}
