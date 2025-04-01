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

func getMaximumEatenDishCount(N: Int, D: [Int], K: Int) -> Int {
    // Constraints
    //   1 ≤ N ≤ 500,000         N is the number of dishes
    //   1 ≤ K ≤ N               K is the number of previous dishes needed to be different
    //   1 ≤ Di ≤ 1,000,000      Di is a dish
    // Complexity: O(N) ~ O(max(N, 1_000_001))   (as asymptotically, N -> +inf)

    // The following is O(1_000_001)
    var eaten = [Bool](repeating: false, count: 1_000_001)  // we could use bitwise operation in c++ (std::vector<bool>)

    // The following is O(K) (where K < N)
    var lastEaten = [Int](repeating: 0, count: K)  // circular buffer for last eaten value (0 is not used, as 1 ≤ Ki ≤ 1,000,000)
    var oldestEaten = 0

    // The following is O(N)
    var nb = 0
    for dish in D.prefix(N) {
        if !eaten[dish] {
            oldestEaten = (oldestEaten + 1) % K
            let lastEatenDish = lastEaten[oldestEaten]
            eaten[lastEatenDish] = false  // we remove the oldest eaten dish
            eaten[dish] = true
            lastEaten[oldestEaten] = dish  // we add the newest eaten dish to our circular buffer
            nb += 1
        }
    }
    return nb
}

// ---------------------------------------

struct TestArgsType {
    var D: [Int]
    var K: Int
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(D: [1, 2, 3, 3, 2, 1], K: 1), 5),
            (TestArgsType(D: [1, 2, 3, 3, 2, 1], K: 2), 4),
            (TestArgsType(D: [1, 2, 1, 2, 1, 2, 1], K: 2), 2),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMaximumEatenDishCount(N: args.D.count, D: args.D, K: args.K) }
    return (wrapper, metaCases)
}
