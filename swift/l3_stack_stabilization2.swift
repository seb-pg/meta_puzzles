func _getMinimumSecondsRequired(N: Int, _R: [Int], A: Int, B: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=290955626029019
    // Constraints :
    //      1 ≤ N    ≤ 50
    //      1 ≤ Ri   ≤ 1,000,000,000
    //      1 ≤ A, B ≤ 100
    // Complexity: O(N ^ 2)

    var R = _R;  // codeconvert had an issue with the immutability of _R
    if N == 0 || R.isEmpty {
        return 0
    }
    var cost = 0
    var costs = Array(repeating: 0, count: N)
    var intervals = [0]
    
    for i in 1..<N {
        let minInflate = R[i - 1] + 1 - R[i]
        // inflate first
        if minInflate > 0 {
            cost += minInflate * A
            R[i] += minInflate
            costs[i] = minInflate
        }
        // track continuous intervals
        if minInflate < 0 {
            intervals.append(i)
            continue
        }
        // deflate eventually
        while true {
            let first = intervals.last!
            let nbTot = i + 1 - first
            
            var nbPos = 0
            var minPos1 = Int.max
            for value in costs[first...i] {
                if value > 0 {
                    nbPos += 1
                    minPos1 = min(minPos1, value)
                }
            }
            
            let minPos2 = (first > 0) ? R[first] - R[first - 1] : R[0]
            let minPos = min(minPos1, minPos2 - 1)
            let nbNeg = nbTot - nbPos
            let costChange = (nbNeg * B - nbPos * A) * minPos
            
            if costChange > 0 {
                break
            }
            cost += costChange
            
            for j in first...i {
                costs[j] -= minPos
                R[j] -= minPos
            }
            if first > 0 {
                if R[first] == R[first - 1] + 1 {
                    intervals.removeLast()
                }
            }
            if minPos <= 0 {
                break
            }
        }
    }
    return cost
}

func getMinimumSecondsRequired(N: Int, R: [Int], A: Int, B: Int) -> Int {
    return _getMinimumSecondsRequired(N: N, _R: R, A: A, B: B)
}

// ---------------------------------------

struct TestArgsType {
    var R: [Int]
    var A: Int
    var B: Int
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(R: [2, 5, 3, 6, 5], A: 1, B: 1), 5),  // -2, +1
            (TestArgsType(R: [100, 100, 100], A: 2, B: 3), 5),
            (TestArgsType(R: [100, 100, 100], A: 7, B: 3), 9),
            (TestArgsType(R: [6, 5, 4, 3], A: 10, B: 1), 19),
            (TestArgsType(R: [100, 100, 1, 1], A: 2, B: 1), 207),
            (TestArgsType(R: [6, 5, 2, 4, 4, 7], A: 1, B: 1), 10),
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(R: [10, 6, 2], A: 2, B: 1), 15),
            (TestArgsType(R: [1, 2, 3, 4, 5, 6], A: 1, B: 1), 0),
            (TestArgsType(R: [6, 5, 4, 3, 2, 1], A: 1, B: 1), 18),
        ])
    ]
    let extra2Cases: MetaCasesT = [
        ("extra2", [
            (TestArgsType(R: [4, 6, 2], A: 2, B: 1), 9),
            (TestArgsType(R: [6, 5, 2, 4, 4, 7], A: 1, B: 1), 10),
            (TestArgsType(R: [2, 5, 3, 6, 5], A: 1, B: 1), 5),  // -2, +1
            (TestArgsType(R: [2, 3, 8, 1, 7, 6], A: 2, B: 1), 15),  // -2, +1
            (TestArgsType(R: [5, 4, 3, 6, 8, 1, 10, 11, 6, 1], A: 4, B: 1), 85),
            (TestArgsType(R: [3, 4, 7, 8, 2], A: 4, B: 1), 24),
            (TestArgsType(R: [1, 1, 1, 1, 1], A: 4, B: 1), 40),
            (TestArgsType(R: [1, 1, 1, 1, 1], A: 1, B: 4), 10),
            (TestArgsType(R: [8, 6, 4, 2], A: 1, B: 4), 18),
            (TestArgsType(R: [1_000_000_000, 500_000_000, 200_000_000, 1_000_000], A: 1, B: 4), 2_299_000_006),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMinimumSecondsRequired(N: args.R.count, R: args.R, A: args.A, B: args.B) }
    return (wrapper, metaCases + extra1Cases + extra2Cases)
}
