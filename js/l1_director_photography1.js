// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getArtisticPhotographCount(N, C, X, Y) {
    // Constraints
    //   1 ≤ N ≤ 200         N is the number of cells in a row
    //   1 ≤ X ≤ Y ≤ N       X,Y are the distance between a photograph and an actor
    // Complexity: O(N) ~ O(N * (Y-X+1)) because Y-X << N

    // Note: the solution is not really elegant speed-wise, but focuses on the algorithm
    // The solution calculates the pairs of sub string (of width w), surrounding 'A' characters, this is O(N)
    const w = Y - X + 1;  // w = width of the interval
    const c = ' '.repeat(Y) + C.slice(0, N) + ' '.repeat(Y);  // make our life easier by adding blank characters

    // calculation sub-intervals: O(N) ~ O(N * (Y-X+1))
    const possible = [];
    for (let i = Y; i <= N + Y; i++) {
        if (c[i] === 'A') {
            possible.push([c.slice(i - Y, i - Y + w), c.slice(i + X, i + X + w)]);
        }
    }

    // Now count the possible combination of (P, B) on both sides of eligible positions: O(N) ~ O(N * (Y-X+1))
    let nb = 0;
    for (const [left, right] of possible) {
        nb += (left.match(/P/g) || []).length * (right.match(/B/g) || []).length;
        nb += (left.match(/B/g) || []).length * (right.match(/P/g) || []).length;
    }
    return nb;
}

function tests() {
    const fn = (C, X, Y) => [C.length, C, X, Y];
    const meta_cases = ["meta", [
        [["APABA", 1, 2], 1],
        [["APABA", 2, 3], 0],
        [[".PBAAP.B", 1, 3], 3],
    ]];
    const extra1_cases = ["extra1", [
        //[["PP.A.BB.B", 1, 3], 2],
    ]];
    return [getArtisticPhotographCount, fn, [meta_cases, extra1_cases]];
}

module.exports = {tests};
