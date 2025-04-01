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

// ---------------------------------------

struct TestArgsType {
    var C: Int
    var A: [Int]
    var B: [Int]
    var K: Int
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(C: 10, A: [1, 6], B: [3, 7], K: 7), 22),
            (TestArgsType(C: 50, A: [39, 19, 28], B: [49, 27, 35], K: 15), 35),
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 1), 20),  // tunnel length = 25 [8, 7, 10]
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 8), 27),
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 9), 29),
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 15), 35),
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 16), 40),
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 25), 49),
            (TestArgsType(C: 50, A: [19, 28, 39], B: [27, 35, 49], K: 26), 50 + 20),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getSecondsElapsed(C: args.C, N: min(args.A.count, args.B.count), A: args.A, B: args.B, K: args.K) }
    return (wrapper, metaCases + extra1Cases)
}
