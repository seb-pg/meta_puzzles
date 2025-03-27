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

function getMinCodeEntryTime(N, M, C) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=990060915068194
    // Constraints
    //      3 ≤ N ≤ 50,000,000      N is the number of integers
    //      1 ≤ M ≤ 1,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M)

    let pos = 1;
    let nb = 0;
    for (let i = 0; i < M; i++) {
        const target = C[i];
        const positiveMove = (target - pos + N) % N; // positive move
        const negativeMove = N - positiveMove;
        nb += Math.min(positiveMove, negativeMove);
        pos = target;
    }
    return nb;
}

function tests() {
    const fn = (N, C) => [N, C.length, C];
    // codeconvert: did not convert the (implicity) tuple ("meta", ...)
    //const metaCases = [
    //    [[3, [1, 2, 3]], 2],
    //    [[10, [9, 4, 4, 8]], 11],
    //];
    //return [getMinCodeEntryTime, fn, metaCases];
    const metaCases = ["meta", [
        [[3, [1, 2, 3]], 2],
        [[10, [9, 4, 4, 8]], 11],
    ]];
    return [getMinCodeEntryTime, fn, [metaCases]];
}

module.exports = {tests};
