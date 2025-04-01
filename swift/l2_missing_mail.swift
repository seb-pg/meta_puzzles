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

func getMaxExpectedProfitDouble(N: Int, V: [Int], C: Int, S: Double) -> Double {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=401886137594615
    // Constraints:
    //      1   ≤ N  ≤ 4,000    N is the number of parcels
    //      0   ≤ Vi ≤ 1,000    Vi is the value of a parcel
    //      1   ≤ C  ≤ 1,000    C is the cost the enter a room
    //      0.0 ≤ S   ≤ 1.0     S is the probability the content of the mailroom is stolen
    // Complexity: O(N^2)

    // codeconvert does not pick up on the variable V not being mutated (var was manually changed to let)
    let V = Array(V.prefix(N))

    if S == 0 {
        return Double(V.reduce(0, +)) - Double(C)
    }

    var solutions: [(Double, Double)] = [(0, 0)]

    for Vi in V {
        solutions = solutions.map { (mailRoomValue: $0.0 * (1 - S), totalValue: $0.1) }

        let pickupValue = Double(Vi) - Double(C) + solutions.map { $0.0 + $0.1 }.max()!

        solutions = solutions.map { (mailRoomValue: $0.0 + Double(Vi), totalValue: $0.1) }
        solutions.append((0, pickupValue))
    }

    return solutions.map { $0.1 }.max()!
}

func getMaxExpectedProfit(_ N: Int, _ V: [Int], _ C: Int, _ S: Float) -> Float {
    // the test is using Float but the converted codeused Double
    return Float(getMaxExpectedProfitDouble(N: N, V: V, C: C, S: Double(S)))
}

// ---------------------------------------

struct TestArgsType {
    var V: [Int]
    var C: Int
    var S: Double
}

typealias RetType = Double
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(V: [10, 2, 8, 6, 4], C: 5, S: 0.0), 25.0),
            (TestArgsType(V: [10, 2, 8, 6, 4], C: 5, S: 1.0), 9.0),
            (TestArgsType(V: [10, 2, 8, 6, 4], C: 3, S: 0.5), 17.0),
            (TestArgsType(V: [10, 2, 8, 6, 4], C: 3, S: 0.15), 20.10825),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMaxExpectedProfitDouble(N: args.V.count, V: args.V, C: args.C, S: args.S) }
    return (wrapper, metaCases)
}
