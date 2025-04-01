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

func getMaxAdditionalDinersCount(N: Int, K: Int, M: Int, S: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=203188678289677
    // Constraints
    //      1 ≤ N ≤ 10^15       N is the number of seats
    //      1 ≤ K ≤ N           K is the number of empty seats needed between occupied seats
    //      1 ≤ M ≤ 500,000     M is the number of diners
    //      1 ≤ Si ≤ N          Si is a seat
    // Complexity: O(M*log(M)), but the complexity could be O(M) if S was sorted

    let taken = S.filter { 1 <= $0 && $0 <= N }.sorted()
    let d = K + 1
    let extendedTaken = [-K] + taken + [N + d]
    let nb = zip(extendedTaken, extendedTaken.dropFirst()).reduce(0) { $0 + max(0, ($1.1 - $1.0 - d) / d) }
    return nb
}

// ---------------------------------------

struct TestArgsType {
    var N: Int
    var K: Int
    var S: [Int]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(N: 10, K: 1, S: [2, 6]), 3),
            (TestArgsType(N: 15, K: 2, S: [11, 6, 14]), 1),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMaxAdditionalDinersCount(N: args.N, K: args.K, M: args.S.count, S: args.S) }
    return (wrapper, metaCases)
}
