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
//      Did not work initially because of the negative modulo (fixed manually)
//      "Time Limit Exceeded on 4 test cases" afterwards

func getDistance(target: Int, position: Int, N: Int) -> Int {
    // codeconvert generating this (error with negative modulo)
    // let positiveMove = (target - position) % N
    // the following correct was added manually
    var positiveMove = (target - position) % N
    if (positiveMove) < 0 {
        positiveMove += N
    }
    let negativeMove = N - positiveMove  // positive number
    return min(positiveMove, negativeMove)
}

struct Pair<T: Hashable, U: Hashable>: Hashable {
  let first: T
  let second: U
}

func getMinCodeEntryTimeOriginalConversionTooSlow(N: Int, M: Int, C: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1637008989815525
    // Constraints:
    //      3 ≤ N ≤ 1,000,000,000   N is the number of integers
    //      1 ≤ M ≤ 3,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M^2)

    if C.isEmpty {
        return 0
    }
    // Uding codeconvert.ai, the key is transformed to a string (like in Javascript) and this is too slow
    var solutions: [String: Int] = ["1,1": 0]
    for (i, target) in C.prefix(M).enumerated() {
        var newSolutions: [String: Int] = [:]
        for (key, distance) in solutions {
            let components = key.split(separator: ",").map { Int($0)! }
            let dial1 = components[0]
            let dial2 = components[1]
            
            // we turn dial1
            let distance1 = distance + getDistance(target: target, position: dial1, N: N)
            let key1 = "\(min(dial2, target)),\(max(dial2, target))"
            newSolutions[key1] = min(newSolutions[key1] ?? Int.max, distance1)
            
            // we turn dial2
            let distance2 = distance + getDistance(target: target, position: dial2, N: N)
            let key2 = "\(min(dial1, target)),\(max(dial1, target))"
            newSolutions[key2] = min(newSolutions[key2] ?? Int.max, distance2)
        }
        solutions = newSolutions
    }
    return solutions.values.min() ?? 0
}

// ---------------------------------------

struct TestArgsType {
    var N: Int
    var C: [Int]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(N: 3, C: [1, 2, 3]), 2),
            (TestArgsType(N: 10, C: [9, 4, 4, 8]), 6),
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("meta", [
            (TestArgsType(N: 0, C: []), 0),
            (TestArgsType(N: 3, C: []), 0),
            (TestArgsType(N: 10, C: []), 0),
            (TestArgsType(N: 10, C: [4]), 3),
            (TestArgsType(N: 10, C: [9]), 2),
            (TestArgsType(N: 10, C: [9, 9, 9, 9]), 2),
        ])
    ]
    let extra2Cases: MetaCasesT = [
        ("meta", [
            (TestArgsType(N: 10, C: [6, 2, 4, 8]), 10),  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
            (TestArgsType(N: 10, C: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]), 9),  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
            (TestArgsType(N: 4, C: [4, 3, 2, 1, 2, 3, 4]), 5),  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMinCodeEntryTimeOriginalConversionTooSlow(N: args.N, M: args.C.count, C: args.C) }
    return (wrapper, metaCases + extra1Cases + extra2Cases)
}
