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

struct DamageInfo {
    var order: Int = 0
    var indices: [Int] = [0, 0]
    var damage: Int = 0
}

func maximizeDamage(N: Int, H: [Int], D: [Int], info: inout DamageInfo) -> Bool {
    var hasSameDamage = true
    for i in 0..<N {
        let index = info.indices[info.order]
        if index == i {
            continue
        }
        let newDamage: Int
        if info.order == 0 {
            newDamage = H[index] * D[index] + H[index] * D[i] + H[i] * D[i]
        } else {
            newDamage = H[i] * D[i] + H[i] * D[index] + H[index] * D[index]
        }
        if info.damage < newDamage {
            hasSameDamage = false
            info.damage = newDamage
            info.indices[1 - info.order] = i
        }
    }
    return hasSameDamage
}

func getMaxDamageDealtDouble(N: Int, H: [Int], D: [Int], B: Int) -> Double {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=149169347195386
    // Constraints :
    //      2 ≤ N  ≤ 500,000
    //      1 ≤ Hi ≤ 1,000,000,000
    //      1 ≤ Di ≤ 1,000,000,000
    //      1 ≤ B  ≤ 1,000,000,000
    // Complexity: O(N^2)

    var damageInfos: [DamageInfo] = []
    for order in 0...1 {
        var damageInfo = DamageInfo(order: order)
        while true {
            let hasSameDamage = maximizeDamage(N: N, H: H, D: D, info: &damageInfo)
            if hasSameDamage {
                break
            }
            damageInfo.order = 1 - damageInfo.order
            damageInfos.append(damageInfo)
        }
    }
    guard !damageInfos.isEmpty else {
        return 0.0
    }
    let maxDamageInfo = damageInfos.max(by: { $0.damage < $1.damage })!
    return Double(maxDamageInfo.damage) / Double(B)
}

func getMaxDamageDealt(N: Int, H: [Int], D: [Int], B: Int) -> Float {
    return Float(getMaxDamageDealtDouble(N: N, H: H, D: D, B: B))
}

// ---------------------------------------

struct TestArgsType {
    var H: [Int]
    var D: [Int]
    var B: Int
}

typealias RetType = Double
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(H: [2, 1, 4], D: [3, 1, 2], B: 4), 6.5),
            (TestArgsType(H: [1, 1, 2, 100], D: [1, 2, 1, 3], B: 8), 62.75),
            (TestArgsType(H: [1, 1, 2, 3], D: [1, 2, 1, 100], B: 8), 62.75),
        ])
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(H: [1, 1, 2, 100, 3], D: [1, 2, 1, 4, 100], B: 8), 1337.5),
            // what if all Hi*Di are equal?
            (TestArgsType(H: [9, 1, 3, 4], D: [0, 10, 4, 3], B: 1), 100.0),
        ])
    ]
    let wrapper: (TestArgsType) -> RetType = { args in getMaxDamageDealtDouble(N: args.H.count, H: args.H, D: args.D, B: args.B) }
    return (wrapper, metaCases + extra1Cases)
}
