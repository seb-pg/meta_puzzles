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
// TODO fix multiple errors in Meta's website
//      You solved 23 / 35 test cases.
//      Wrong Answer on 12 test cases
// This solution should be correct, and it is worth nothing that the signature of Meta's
// function is [[String]] while it should be [String], which is similar to the Kotlin's
// solution which does not work on Meta's website (but we be expected to work)

import Foundation

func getCounts(row: String, counts: inout [Int]) -> (Int, Int, Int) {
    // codeconvert: lines below generate: error: cannot convert value of type 'UInt8' to expected argument type 'Int'
    //              because the cast to Int is missing
    counts[Int(Character("*").asciiValue!)] = 0
    counts[Int(Character(">").asciiValue!)] = 0
    counts[Int(Character("v").asciiValue!)] = 0
    for c in row {
        var ordC = Int(c.asciiValue!)
        if ordC >= 256 {
            ordC = Int(Character(".").asciiValue!)
        }
        counts[ordC] += 1
    }
    let countStar = counts[Int(Character("*").asciiValue!)]
    let countRight = counts[Int(Character(">").asciiValue!)]
    let countDown = counts[Int(Character("v").asciiValue!)]
    return (countStar, countRight, countDown)
}

func getNbCoinsRightThenDown3(row: String, countDown: inout Int, countRight: inout Int) -> Int {
    if countDown == 0 {
        return 0
    }
    // codeconvert does not generated a great solution
    // made the solution much simpler manually
    let j = row.firstIndex(of: "v")!.utf16Offset(in: row) + 1
    let jidx = row.index(row.startIndex, offsetBy: j)
    let newRow = row[jidx...] + row[..<jidx]
    var nbCoinsRightThenDown = 0
    var last = 0
    while countRight * countDown != 0 {
        let subString1 = newRow[newRow.firstIndex(of: ">")!...]
        let subString2 = subString1[..<subString1.firstIndex(of: "v")!]  // +1 is not necessary
        nbCoinsRightThenDown = max(nbCoinsRightThenDown, subString2.filter { $0 == "*" }.count)
        countDown -= 1
        countRight -= subString2.filter { $0 == ">" }.count
    }
    return nbCoinsRightThenDown
}

func getMaxCollectableCoinsAsExpected(R: Int, C: Int, G: [String]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=2881982598796847
    // Constraints
    //      2 ≤ R, C ≤ 400, 000
    //      R∗C ≤ 800, 000
    //      Gi, j ∈{ ".", "*", ">", "v" }
    //      Complexity: O(N), where N = R * C

    var counts = Array(repeating: 0, count: 256)
    var res = 0
    for row in G.reversed() {
        let (countStar, countRight, countDown) = getCounts(row: row, counts: &counts)
        let nbCoinsImmediatelyDown = min(countStar, 1)
        if countRight == C {
            res = 0
        } else if countRight == 0 {
            res += nbCoinsImmediatelyDown
        } else {
            var countDownCopy = countDown
            var countRightCopy = countRight
            let nbCoinsRightThenDown = getNbCoinsRightThenDown3(row: row, countDown: &countDownCopy, countRight: &countRightCopy)
            // codeconvert has an issue with the following like
            //let nbCoinsRightForever = countStar if countDown == 0 else 0
            let nbCoinsRightForever = countDown == 0 ? countStar : 0
            res = max(nbCoinsImmediatelyDown + res, nbCoinsRightThenDown + res, nbCoinsRightForever)
        }
    }
    return res
}

func getMaxCollectableCoins(R: Int, C: Int, G: [[String]]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=2881982598796847
    // Constraints
    //      2 ≤ R, C ≤ 400, 000
    //      R∗C ≤ 800, 000
    //      Gi, j ∈{ ".", "*", ">", "v" }
    //      Complexity: O(N), where N = R * C

    var H: [String] = [];
    for in_row in G {
        for elt in in_row {
            H.append(elt)
            break
        }
        //H.append(in_row.joined())
    }
    return getMaxCollectableCoinsAsExpected(R: R, C: C, G: H)
}

// ---------------------------------------

struct TestArgsType {
    var G: [String]
}

typealias RetType = Int
typealias MetaCasesT = [(String, [(TestArgsType, RetType)])]

func tests() -> ((TestArgsType) -> RetType, MetaCasesT) {
    let metaCases: MetaCasesT = [
        ("meta", [
            (TestArgsType(G: [".***", "**v>", ".*.."]), 4),
            (TestArgsType(G: [">**", "*>*", "**>"]), 4),
            (TestArgsType(G: [">>", "**"]), 0),
            (TestArgsType(G: [">*v*>*", "*v*v>*", ".*>..*", ".*..*v"]), 6),
        ]),
    ]
    let extra1Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(G: []), 0),
            (TestArgsType(G: ["."]), 0),
            (TestArgsType(G: ["v"]), 0),
            (TestArgsType(G: [">"]), 0),
            (TestArgsType(G: ["*"]), 1),
        ])
    ]
    let extra2Cases: MetaCasesT = [
        ("extra2", [
            (TestArgsType(G: [".", ".", ">", "*"]), 0),
            (TestArgsType(G: [".", "*", ">", "*"]), 1),
            (TestArgsType(G: [".", "*", ">", "."]), 1),
            (TestArgsType(G: ["*", ".", ">", "."]), 1),
            (TestArgsType(G: ["***", "...", ">vv", "..."]), 1),
        ])
    ]
    let extra3Cases: MetaCasesT = [
        ("extra3", [
            (TestArgsType(G: ["*....", ".*...", "..*..", "...*."]), 4),
            (TestArgsType(G: ["....", "....", "....", "...."]), 0),
            (TestArgsType(G: ["***>", "...."]), 3),
            (TestArgsType(G: ["...."]), 0),
            (TestArgsType(G: ["vvvv"]), 0),
            (TestArgsType(G: ["vvvv", "....", ">>>>"]), 0),
        ])
    ]
    let extra4Cases: MetaCasesT = [
        ("extra1", [
            (TestArgsType(G: ["******", "......", ">*>vvv", "......"]), 2),
            (TestArgsType(G: ["*****", ".....", ">>vvv", "....."]), 1),
        ])
    ]
    //let wrapper: (TestArgsType) -> RetType = { args in getMaxCollectableCoinsTest(R: args.G.count, C: args.G[0].count, G: args.G) }
    let wrapper: (TestArgsType) -> RetType = { args in getMaxCollectableCoinsAsExpected(R: args.G.count, C: args.G.count > 0 ? args.G[0].count : 0, G: args.G) }
    return (wrapper, metaCases + extra1Cases + extra2Cases + extra3Cases + extra4Cases)
}
