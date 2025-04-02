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
    let j = row.firstIndex(of: "v")!.utf16Offset(in: row) + 1
    let newRow = String(row[row.index(row.startIndex, offsetBy: j)...]) + String(row[row.startIndex..<row.index(row.startIndex, offsetBy: j)])
    var nbCoinsRightThenDown = 0
    var last = 0
    while countRight * countDown != 0 {
        guard let first = newRow.firstIndex(of: ">")?.utf16Offset(in: newRow),
              let nextV = newRow[newRow.index(newRow.startIndex, offsetBy: first)...].firstIndex(of: "v")?.utf16Offset(in: newRow) else {
            break
        }
        last = nextV + 1
        nbCoinsRightThenDown = max(nbCoinsRightThenDown, newRow[newRow.index(newRow.startIndex, offsetBy: first)..<newRow.index(newRow.startIndex, offsetBy: last)].filter { $0 == "*" }.count)
        countDown -= 1
        countRight -= newRow[newRow.index(newRow.startIndex, offsetBy: first)..<newRow.index(newRow.startIndex, offsetBy: last)].filter { $0 == ">" }.count
    }
    return nbCoinsRightThenDown
}

func getMaxCollectableCoins(R: Int, C: Int, G: [[String]]) -> Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=2881982598796847
    // Constraints
    //      2 ≤ R, C ≤ 400, 000
    //      R∗C ≤ 800, 000
    //      Gi, j ∈{ ".", "*", ">", "v" }
    //      Complexity: O(N), where N = R * C

    var counts = Array(repeating: 0, count: 256)
    var res = 0
    for row in G.reversed() {
        let (countStar, countRight, countDown) = getCounts(row: row.joined(), counts: &counts)
        let nbCoinsImmediatelyDown = min(countStar, 1)
        if countRight == C {
            res = 0
        } else if countRight == 0 {
            res += nbCoinsImmediatelyDown
        } else {
            var countDownCopy = countDown
            var countRightCopy = countRight
            let nbCoinsRightThenDown = getNbCoinsRightThenDown3(row: row.joined(), countDown: &countDownCopy, countRight: &countRightCopy)
            // codeconvert has an issue with the following like
            //let nbCoinsRightForever = countStar if countDown == 0 else 0
            let nbCoinsRightForever = countDown == 0 ? countStar : 0
            res = max(nbCoinsImmediatelyDown + res, nbCoinsRightThenDown + res, nbCoinsRightForever)
        }
    }
    return res
}

func tests() -> ( ( [[String]] ) -> Int, ( [[String]] ) -> (Int, Int, [[String]]) ) -> (Int, Int, [[String]]) ) {
    let fn: ([[String]]) -> (Int, Int, [[String]]) = { G in (G.count, G.first?.count ?? 0, G) }
    
    let metaCases = ("meta", [
        ([".***", "**v>", ".*.."], 4),
        ([">**", "*>*", "**>"], 4),
        ([">>", "**"], 0),
        ([">*v*>*", "*v*v>*", ".*>..*", ".*..*v"], 6),
    ])
    let extra1Cases = ("extra1", [
        ([], 0),
        (["."], 0),
        (["v"], 0),
        ([">"], 0),
        (["*"], 1),
    ])
    let extra2Cases = ("extra2", [
        ([".", ".", ">", "*"], 0),
        ([".", "*", ">", "*"], 1),
        ([".", "*", ">", "."], 1),
        (["*", ".", ">", "."], 1),
        (["***", "...", ">vv", "..."], 1),
    ])
    let extra3Cases = ("extra3", [
        (["*....", ".*...", "..*..", "...*."], 4),
        (["....", "....", "....", "...."], 0),
        (["***>", "...."], 3),
        (["...."], 0),
        (["vvvv"], 0),
        (["vvvv", "....", ">>>>"], 0),
    ])
    let extra4Cases = ("extra4", [
        (["******", "......", ">*>vvv", "......"], 2),
        (["*****", ".....", ">>vvv", "....."], 1),
    ])
    return (getMaxCollectableCoins, fn, [metaCases, extra1Cases, extra2Cases, extra3Cases, extra4Cases])
}
