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

func getSecondsElapsed(C: Int, N: Int, A: [Int], B: [Int], K: Int) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1492699897743843
    // Constraints:
    //      3 ≤ C ≤ 10^12       C is the circumference
    //      1 ≤ N ≤ 500,000     N is the number of tunnels
    //      1 ≤ Ai < Bi ≤ C     Ai and Bi are the start and end of the tunnels
    //      1 ≤ K ≤ 10^12       K is the time spent in tunnels
    // Complexity: O(N*log(N)), would be O(N) if tunnels were sorted

    let tunnelTimeTotal = zip(A, B).map { $1 - $0 }.reduce(0, +)  // O(N)
    let numberOfCompleteTrack = K / tunnelTimeTotal  // O(1)
    var totalTimeLeft = K - numberOfCompleteTrack * tunnelTimeTotal  // O(1)
    var travelTime = numberOfCompleteTrack * C  // O(1)
    
    if totalTimeLeft == 0 {
        travelTime -= C - B.max()!  // O(N)
    } else {
        let tunnels = zip(A, B).sorted { $0.0 < $1.0 }  // O(N*log(N))
        for (a, b) in tunnels {  // O(N)
            let tunnelLength = b - a
            if tunnelLength >= totalTimeLeft {
                travelTime += a + totalTimeLeft
                break
            }
            totalTimeLeft -= tunnelLength
        }
    }
    return travelTime
}

func tests1() -> (getSecondsElapsed: (Int, Int, [Int], [Int], Int) -> Int, fn: (Int, [Int], [Int], Int) -> (Int, Int, [Int], [Int], Int), cases: [(String, [((Int, [Int], [Int], Int), Int)])]) ) {
    func fn(C: Int, A: [Int], B: [Int], K: Int) -> (Int, Int, [Int], [Int], Int) {
        return (C, min(A.count, B.count), A, B, K)
    }
    
    let meta_cases = ("meta", [
        ((10, [1, 6], [3, 7], 7), 22),
        ((50, [39, 19, 28], [49, 27, 35], 15), 35),
    ])
    
    let extra1_cases = ("extra1", [
        ((50, [19, 28, 39], [27, 35, 49], 1), 20),
        ((50, [19, 28, 39], [27, 35, 49], 8), 27),
        ((50, [19, 28, 39], [27, 35, 49], 9), 29),
        ((50, [19, 28, 39], [27, 35, 49], 15), 35),
        ((50, [19, 28, 39], [27, 35, 49], 16), 40),
        ((50, [19, 28, 39], [27, 35, 49], 25), 49),
        ((50, [19, 28, 39], [27, 35, 49], 26), 50 + 20),
    ])
    
    return (getSecondsElapsed, fn, [meta_cases, extra1_cases])
}
