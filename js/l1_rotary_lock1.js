// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getMinCodeEntryTime(N, M, C) {
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
