// This was converted from Python to Javascript using https://www.codeconvert.ai/

const fs = require('fs');
const path = require('path');

function getLocalModules() {
    // codeconvert: I am impressed byt the code conversion!
    const dirname = __dirname;
    const files = fs.readdirSync(dirname);
    const pattern = /^l\d_.*\.js$/;   // codeconvert: py was changed to js to make it work
    const filteredFiles = files.filter(f => pattern.test(f)).sort().map(f => f.slice(0, -3));
    const testsFns = [];
    for (const f of filteredFiles) {
        const m = require(path.join(dirname, f));
        if (m) {
            const fn = m.tests || null;
            if (fn) {
                testsFns.push([f, fn]);
            }
        }
    }
    return testsFns;
}

function formatArgs(args) {
    return;
}

if (require.main === module) {
    const testsFns = getLocalModules();
    let nbErrors = 0;

    for (const [testsName, testsFn] of testsFns) {
        console.log("testsName: " + testsName);
        const ret = testsFn();
        const [testFn, extendFn, allTests] = ret.slice(0, 3);
        const cmp = (res, exp) => res === exp;

        let customCmp = cmp;
        if (ret.length > 3) {
            customCmp = ret[3];
        }

        for (const [subName, tests] of allTests) {
            console.log();
            console.log(testsName, subName);
            if (!tests.length) {
                console.log("  no tests");
                continue;
            }

            for (let nb = 0; nb < tests.length; nb++) {
                const [args, expected] = tests[nb];
                const exArgs = extendFn(...args);
                const res = testFn(...exArgs);

                if (customCmp(res, expected)) {
                    console.log(`  ${subName}, test #${nb + 1}: res=${res} CORRECT`);
                } else {
                    console.log(`  ${subName}, test #${nb + 1}: res=${res} expected=${expected} ERROR <-----`);
                    nbErrors += 1;
                }
            }
        }
    }
    console.log(`\n${nbErrors} errors found`);
}
