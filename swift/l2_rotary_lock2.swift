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

func getMinCodeEntryTime(N: Int, M: Int, C: [Int]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1637008989815525
    // Constraints:
    //      3 ≤ N ≤ 1,000,000,000   N is the number of integers
    //      1 ≤ M ≤ 3,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M^2)

    if C.isEmpty {
        return 0
    }
    var solutions: [Pair<Int, Int>: Int] = [Pair(first: 1, second: 1): 0]
    for (i, target) in C.prefix(M).enumerated() {
        var newSolutions: [Pair<Int, Int>: Int] = [:]
        for (key, distance) in solutions {
            let dial1 = key.first
            let dial2 = key.second
            // we turn dial1
            let distance1 = distance + getDistance(target: target, position: dial1, N: N)
            let key1 = Pair(first: min(dial2, target), second: max(dial2, target))
            newSolutions[key1] = min(newSolutions[key1] ?? Int.max, distance1)
            
            // we turn dial2
            let distance2 = distance + getDistance(target: target, position: dial2, N: N)
            let key2 = Pair(first: min(dial1, target), second: max(dial1, target))
            newSolutions[key2] = min(newSolutions[key2] ?? Int.max, distance2)
        }
        solutions = newSolutions
    }
    return solutions.values.min() ?? 0
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

func tests2() -> (getMinCodeEntryTime: (Int, Int, [Int]) -> Int, fn: (Int, [Int]) -> (Int, Int, [Int]), cases: [(String, [(Int, [Int])])]) {
    func fn(N: Int, C: [Int]) -> (Int, Int, [Int]) {
        return (N, C.count, C)
    }
    let metaCases: (String, [(Int, [Int])]) = ("meta", [
        (3, [1, 2, 3]),
        (10, [9, 4, 4, 8]),
    ])
    let extra1Cases: (String, [(Int, [Int])]) = ("extra1", [
        (0, []),
        (3, []),
        (10, []),
        (10, [4]),
        (10, [9]),
        (10, [9, 9, 9, 9]),
    ])
    let extra2Cases: (String, [(Int, [Int])]) = ("extra2", [
        (10, [6, 2, 4, 8]),
        (10, [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]),
        (4, [4, 3, 2, 1, 2, 3, 4]),
    ])
    return (getMinCodeEntryTime, fn, [metaCases, extra1Cases, extra2Cases])
}
