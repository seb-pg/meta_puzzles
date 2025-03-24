// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getMaxAdditionalDinersCount(N, K, M, S) {
    // Constraints
    //   1 ≤ N ≤ 10^15       N is the number of seats
    //   1 ≤ K ≤ N           K is the number of empty seats needed between occupied seats
    //   1 ≤ M ≤ 500,000     M is the number of diners
    //   1 ≤ Si ≤ N          Si is a seat
    // Complexity: O(M*log(M)), but the complexity could be O(M) if S was sorted

    // First, we sort elements of S: O(M*log(M))
    // and we are checking seat positions are valid too (1 <= si <= N)
    const taken = S.filter(si => 1 <= si && si <= N).sort((a, b) => a - b);

    // we are adding "fake" seats at the beginning and end to have a single loop: O(M)
    const d = K + 1;
    taken.unshift(-K);
    taken.push(N + d);

    // we are calculating the extra seats available between each consecutive seats: O(M)
    /*
    // this code was the original code produce https://www.codeconvert.ai/
    const nb = taken.reduce((acc, a, i) => {
        if (i > 0) {
            const b = taken[i - 1];
            acc += Math.max(0, Math.floor((a - b - d) / d));
        }
        return acc;
    }, 0);
    */
    // the above code has been changed to be closer to the Python code
    const nb = taken.reduce((acc, b, i) => {
        if (i > 0) {
            const a = taken[i - 1];
            acc += Math.floor((b - a - d) / d);
        }
        return acc;
    }, 0);
    
    return nb;
}

function tests() {
    const fn = (N, K, S) => [N, K, S.length, S];
    const meta_cases = ["meta", [
        [[10, 1, [2, 6]], 3],
        [[15, 2, [11, 6, 14]], 1],
    ]];
    return [getMaxAdditionalDinersCount, fn, [meta_cases]];
}

module.exports = {tests};
