// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getSecondsRequired(N, F, P) {
    // Constraints:
    // 2 ≤ N ≤ 10^12
    // 1 ≤ F ≤ 500,000
    // 1 ≤ Pi ≤ N−1
    // Complexity: O(N), but could be O(1) if P was sorted

    // When you think about it, the solution is very simple!
    //return N - Math.min(...P.slice(0, F));  // Runtime Error on 2 test cases -> too slow!
    return N - P.slice(0, F).reduce((min_value, value, i) => {
        return Math.min(min_value, value);
    }, P[0]);
}

function tests() {
    const fn = (N, P) => [N, P.length, P];
    
    const meta_cases = ["meta", [
        [[3, [1]], 2],
        [[6, [5, 2, 4]], 4],
    ]];
    
    //return { getSecondsRequired, fn, meta_cases };
    return [getSecondsRequired, fn, [meta_cases]];
}

module.exports = {tests};
