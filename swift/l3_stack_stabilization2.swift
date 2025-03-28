func _getMinimumSecondsRequired(N: Int, _R: [Int], A: Int, B: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=290955626029019
    // Constraints :
    //      1 ≤ N    ≤ 50
    //      1 ≤ Ri   ≤ 1,000,000,000
    //      1 ≤ A, B ≤ 100
    // Complexity: O(N ^ 2)

    if N == 0 || R.isEmpty {
        return 0
    }
    var cost = 0
    var costs = Array(repeating: 0, count: N)
    var intervals = [0]
    var R = _R;  // codeconvert had an issue with the immutability of _R
    
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

func getMinimumSecondsRequired(N: Int, _R: [Int], A: Int, B: Int) -> Int {
    return _getMinimumSecondsRequired(N: N, _R: R, A: A, B: B)
}

func tests() -> (getMinimumSecondsRequired: (Int, [Int], Int, Int) -> Int, fn: ( [Int], Int, Int) -> (Int, [Int], Int, Int), cases: [(String, [(([Int], Int, Int), Int)])]) ) {
    func fn(R: [Int], A: Int, B: Int) -> (Int, [Int], Int, Int) {
        return (R.count, R, A, B)
    }

    let meta_cases = ("meta", [
        (([2, 5, 3, 6, 5], 1, 1), 5),
        (([100, 100, 100], 2, 3), 5),
        (([100, 100, 100], 7, 3), 9),
        (([6, 5, 4, 3], 10, 1), 19),
        (([100, 100, 1, 1], 2, 1), 207),
        (([6, 5, 2, 4, 4, 7], 1, 1), 10),
    ])
    
    let extra1_cases = ("extra1", [
        (([10, 6, 2], 2, 1), 15),
        (([1, 2, 3, 4, 5, 6], 1, 1), 0),
        (([6, 5, 4, 3, 2, 1], 1, 1), 18),
    ])
    
    let extra2_cases = ("extra2", [
        (([4, 6, 2], 2, 1), 9),
        (([6, 5, 2, 4, 4, 7], 1, 1), 10),
        (([2, 5, 3, 6, 5], 1, 1), 5),
        (([2, 3, 8, 1, 7, 6], 2, 1), 15),
        (([5, 4, 3, 6, 8, 1, 10, 11, 6, 1], 4, 1), 85),
        (([3, 4, 7, 8, 2], 4, 1), 24),
        (([1, 1, 1, 1, 1], 4, 1), 40),
        (([1, 1, 1, 1, 1], 1, 4), 10),
        (([8, 6, 4, 2], 1, 4), 18),
        (([1_000_000_000, 500_000_000, 200_000_000, 1_000_000], 1, 4), 2_299_000_006),
    ])
    
    return (getMinimumSecondsRequired, fn, [meta_cases, extra1_cases, extra2_cases])
}
