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
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=503122501113518
    // Constraints:
    //      1 ≤ N ≤ 500,000
    //      1 ≤ i ≤ 1,000,000,000
    // Complexity: O(N)

    var maxScore = 0
    var secondMaxScore = 0
    var twoRemainder = 0
    var oneRemainder = 0
    var needOne = false
    
    for score in S.prefix(N) {
        let scoreMod3 = score % 3
        twoRemainder |= (scoreMod3 >> 1)
        oneRemainder |= (scoreMod3 & 1)
        needOne = needOne || (score == 1)
        if maxScore < score {
            secondMaxScore = maxScore
            maxScore = score
        } else if secondMaxScore < score {
            secondMaxScore = score
        }
    }

    // number of solutions, without any optimisation
    var count = maxScore / 3 + twoRemainder + oneRemainder

    // not optimisation is possible if "twoRemainder and oneRemainder" is not true
    if twoRemainder * oneRemainder != 1 {
        return count
    }

    // replace "last +3" by "+1+2"
    if maxScore % 3 == 0 {
        count -= 1
    }

    // replace last "+3+1" by "+2+2"
    if needOne { // exit early because 1 is required but at least one sum (i.e. it cannot be replaced)
        return count
    }
    if maxScore % 3 != 1 { // maxScore does not have a 1 (so it cannot be replaced)
        return count
    }
    if (maxScore - secondMaxScore) != 1 && (maxScore - secondMaxScore) != 3 { // [ ok, not ok (3), ok ] || [ not ok (1) | here | unimportant ]
        count -= 1
    }
    return count
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
            (TestArgsType(S: [1, 2, 3, 4, 5]), 3),       // problems would be [1, 1, 3]
            (TestArgsType(S: [4, 3, 3, 4]), 2),          // problems would be [1, 3]
            (TestArgsType(S: [2, 4, 6, 8]), 4),          // problems would be [2, 2, 2, 2]
            (TestArgsType(S: [8]), 3),                   // problems would be [2, 3, 3]
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(S: [1, 2, 3, 4, 5]), 3),       // problems would be [1, 1, 3]
            (TestArgsType(S: [4, 3, 3, 4]), 2),          // problems would be [1, 3]
            (TestArgsType(S: [2, 4, 6, 8]), 4),          // problems would be [2, 2, 2, 2]
            (TestArgsType(S: [8]), 3),                   // problems would be [2, 3, 3]
            (TestArgsType(S: [1, 2, 3]), 2),             // problems would be [2, 2, 2]
            (TestArgsType(S: [5, 7]), 3),                // problems would be [(3+2), (3+2+2)]
            (TestArgsType(S: [5, 9, 10]), 5),            // problems would be [(3+0+2+0), (3+3+0+0), (3+3+0+1)]
            (TestArgsType(S: [5, 9, 11]), 4),            // problems would be [(3+0+2), (3+3+0), (3+3+2)]
            (TestArgsType(S: [2, 4, 6]), 3),             // problems would be [(2+0+0), (2+2+0), (2+2+2)]
            (TestArgsType(S: [2, 4, 7]), 4),             // problems would be [(2+0+0), (2+2+0), (2+2+3)]
        ])
    ]
    let extra2Cases: MetaCasesT = [
        ("extra2", [
            (TestArgsType(S: [1, 2, 4]), 3),  // problems would be [(1+0+0+0), (0+2+0+0), (0+2+2)]
            (TestArgsType(S: [2, 4]), 2),  // problems would be [(2+0), (2+2)]
            (TestArgsType(S: [4, 5]), 3),  // problems would be [(2+2), (2+2+1) or (2+3)]
            (TestArgsType(S: [9, 12]), 4),  // problems would be [(3+3+3), (3+3+3+3)]
            (TestArgsType(S: [11, 13]), 5),  // problems would be [(3+3+3+2), (3+3+3+3+1=3+3+3+2+2)]
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMinProblemCount(N: args.S.count, S: args.S) }
    return (wrapper, metaCases + extra1Cases + extra2Cases)
}
