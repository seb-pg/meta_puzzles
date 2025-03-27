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

// This was converted from Python to Javascript using https://www.codeconvert.ai/
// The converted code was too slow to passes Meta testing framework
//      You solved 36 / 39 test cases.
//      Runtime Error on 3 test cases.

function getArtisticPhotographCount(N, C, X, Y) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=156565259776376
    // Constraints
    //      1 ≤ N ≤ 200         N is the number of cells in a row
    //      1 ≤ X ≤ Y ≤ N       X,Y are the distance between a photograph and an actor
    // Complexity: O(N) ~ O(N * (Y-X+1)) because Y-X << N

    C = C.slice(0, N); // this is to be sure N = len(C)

    // count the number of Ps or Bs till a position i: O(N)
    const w = Y + 1;
    let count_p = 0, count_b = 0;
    const ps = Array(w).fill(0);
    const bs = Array(w).fill(0);
    for (const ci of C) {
        if (ci === 'P') {
            count_p++;
        } else if (ci === 'B') {
            count_b++;
        }
        //counts.push(new Counts(count_p, count_b));
        ps.push(count_p);
        bs.push(count_b);
    }
    let last = C.length + w - 1;
    ps.push(...Array(w).fill(ps[last])); // add space at the end to avoid special treatment of indices later
    bs.push(...Array(w).fill(bs[last])); // add space at the end to avoid special treatment of indices later

    // To make things more readable, we are finding first the point where 'A' is found: O(N)
    // Runtime Error on 3 test cases
    const possible = Array.from(C).map((ci, i) => ci === 'A' ? i + w : -1).filter(i => i !== -1); // counting PAB

    // Count PABs: O(N)
    // Count BAPs: O(N)
    let nb1 = 0, nb2 = 0;
    for (const i of possible) {
        nb1 += (ps[i - X] - ps[i - Y - 1]) * (bs[i + Y] - bs[i + X - 1]);
        nb2 += (bs[i - X] - bs[i - Y - 1]) * (ps[i + Y] - ps[i + X - 1]);
    }    

    return nb1 + nb2;
}

function tests() {
    const fn = (C, X, Y) => [C.length, C, X, Y];
    const meta_cases = ["meta", [
        [["APABA", 1, 2], 1],
        [["APABA", 2, 3], 0],
        [[".PBAAP.B", 1, 3], 3],
    ]];
    const extra1_cases = ["extra1", [
        [["PP.A.BB.B", 1, 3], 4],
    ]];
    return [getArtisticPhotographCount, fn, [meta_cases, extra1_cases]];
}

module.exports = {tests};


// The code below was the original conversion from Python to Javascript using https://www.codeconvert.ai/

/*
class Counts {
    constructor(p, b) {
        this.p = p;
        this.b = b;
    }
}

function getArtisticPhotographCount(N, C, X, Y) {
    C = C.slice(0, N); // this is to be sure N = len(C)

    // count the number of Ps or Bs till a position i: O(N)
    const w = Y + 1;
    let count_p = 0, count_b = 0;
    const counts = Array(w).fill(new Counts(0, 0)); // add space at the beginning to avoid special treatment of indices later
    for (const ci of C) {
        if (ci === 'P') {
            count_p++;
        } else if (ci === 'B') {
            count_b++;
        }
        counts.push(new Counts(count_p, count_b));
    }
    counts.push(...Array(w).fill(counts[counts.length - 1])); // add space at the end to avoid special treatment of indices later

    // To make things more readable, we are finding first the point where 'A' is found: O(N)
    //const possible = [...C].map((ci, i) => ci === 'A' ? i + w : -1).filter(i => i !== -1); // counting PAB
    const possible = Array.from(C).map((ci, i) => ci === 'A' ? i + w : -1).filter(i => i !== -1); // counting PAB

    // Count PABs: O(N)
    const nb1 = possible.reduce((sum, i) => {
        return sum + (counts[i - X].p - counts[i - Y - 1].p) * (counts[i + Y].b - counts[i + X - 1].b);
    }, 0);

    // Count BAPs: O(N)
    const nb2 = possible.reduce((sum, i) => {
        return sum + (counts[i - X].b - counts[i - Y - 1].b) * (counts[i + Y].p - counts[i + X - 1].p);
    }, 0);
    
    return nb1 + nb2;
}
*/
