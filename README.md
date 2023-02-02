# meta_puzzles

Author: [Sébastien Rubens](https://www.linkedin.com/in/sebastienrubens/)

----

## Licensing (creative commons CC0)

To the extent possible under law, the person who associated CC0 with
meta_puzzles has waived all copyright and related or neighboring rights
to meta_puzzles.

You should have received a copy of the CC0 legalcode along with this
work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.


----

## meta_puzzles

meta_puzzles are solutions to the Meta/Facebook puzzles available on Meta's careers website at https://www.metacareers.com/profile/coding_puzzles/.

The complete solutions are provided in the following languages:
* Python (3): developed first.
* C\++ (17): developed second. The code is written in a "plausible" medium developer style (it just works with basic C++ and no fancy optimisation.

Mostly complete solutions are provided in the following languages and are based on the C\++17 version (only "level 4" solutions are missing)
* C#: compatible with .Net 7.0 and mostly compatible with .Net Code 3.1.
* Rust: tested with version 1.66.
* Go: tested with version 1.9.4. Solutions are using generics which are not supported by Meta online tests.
* Kotlin: tested with version 1.7.21. See notes!

Languages probably provided in the future
* Java: 4 out of 24 done so far. See notes!
* Javascript
* Scala: 19 out of 24 done so far. See notes!
* Swift

The intent is to use these solutions in a multi-language comparison and find which languages would be suitable to write quantitative strategies on a wide scale.

If you are working for a hedge fund (or a bank) and have many people writing trading strategies, one might want to use a common language for that purpose. A possible model is to use an easy language, such as Python, and "productionize" strategies with "real software developer".  Another model is to use a language easy to pick up, less likely to create problem (on a wide scale), offers good performances, and overall, provide a good value for money.

This first phase is about comparing basic language ecosystem needs, i.e. just the language with some basic collections.


----

## Want to contribute?

Any contribution (code, comments, criticism) is more than welcome.

While I have had to write code in all sort of languages (including some obscure Ada,Cobol, Prolog, Lisp, Pascal, etc) during my academic or professional life, I am mostly a C\++ and Python programmer these days, so if you feel I mistreated a particular language, please contribute!


----
## Files description


<b><u>py3/*</u></b>

The solutions using Python 3 (complete), all tested on Meta's website.

The solutions provided are passing all Meta's tests on their website. Meta's basic tests and some additional are also provided in the source code.

Written in my "quick and dirty" Python style.

"sortedcontainers" has been used to provide "binary tree" like containers/collections needed to solve l4_conveyor_chaos and l4_mathematical_art.


<b><u>cpp17/*</u></b>

The solutions using C\++17 (complete).

The solutions provided  are passing all Meta's tests on their website. Meta's basic tests and some additional are also provided in the source code.

C\++20 (or C\++23) would have helped making the code shorter and easier to read, but Meta's website is stuck in C\++17.


The code is written using a "plausible" medium developer style, and not much emphasis is spent on optimisation:
* Meta passes containers, such as std::vector or std::string by value, rather than reference.  The signature are kept but all functions are calling a more more C\++ style function using reference, which can be used for performance testing.
* Meta used int and long long and seemed to assume they were, respectively, 32 bits and 64 bits.  int32_t/int64_t are used instead passed Meta's function signature.  
* Meta only used signed integer, rather than using the correct signed/unsigned integer (e.g. distances/counts should always be positive). To make code more readable, minimum casting has been used in the code for readibility, even if sometimes, it was tempting to do the right thing in term of sign correctness.
* shared_ptr are sometimes used, intentionally, even when not needed as it matches the Python's code and provides an additional comparison opportunity.
* l3_rabbit_hole2: iterative and recursive solutions are provided (could be interested for speed benchmark).
* l4_mathematical_art: for GCC, the  solution can use "order_of_key" on std::set to match Python's code as std::distance in STL is linear on std::set, not logarithmic.


<b><u>cs/*</u></b>

The solutions using C#, ported from C++ (mostly complete, 2 solutions missing).

The solutions provided are passing all Meta's tests on their website. Meta's basic tests and some additional are also provided in the source code.

Solutions l4_conveyor_chaos and l4_mathematical_art are missing because C# does not provided a log(n) equivalent of [C\++] std::lower_bound for [C\++] std::set or std::map equivalents.

Solution l2_missing_mail and l3_rabbit_hole2 will not be working with .Net Code 3.1, respectively because MaxBy and CollectionsMarshal are missing.


<b><u>go/*</u></b>

The solutions using Go, "ported" from C++ (mostly complete, 3 solutions are missing).

The solutions provided are passing all Meta's tests on their website (once the generics are removed: they are not supported by Meta's website). Meta's basic tests and some additional are also provided in the source code.

Solutions l2_portals, l4_conveyor_chaos and l4_mathematical_art are missing because an equivalent of [C\++] std::set is needed.


<b><u>rs/*</u></b>

The solutions in Rust, "ported" from C++ (mostly complete, 2 solutions are missing).

The solutions provided are passing all Meta's tests on their website. Meta's basic tests and some additional are also provided in the source code.

Solutions l4_conveyor_chaos and l4_mathematical_art are missing because it is not (yet) obvious if Rust is providing a (log(n)) equivalent of [C\++] std::lower_bound for std::set, where it is necessary (because of speed requirement) for l4_conveyor_chaos and l4_mathematical_art.


<b><u>kotlin/*</u></b>

The solutions using Kotlin, "ported" from C++ (mostly complete, 2 solutions are missing, however 3 solutions should be working, but do not work on Meta's website: see below).

The solutions provided are passing all Meta's tests on their website. Meta's basic tests and some additional are also provided in the source code.

Solutions l2_portals and l3_slippery_strip should be working (all provided tests are working) but Meta's website seem to have a bug. The common pattern is that a grid of character is the input.  It could be provided as Array<String> or Array<Array<Char>> (to be the similar to the tests in other languages) but has been provided as  Array<Array<String>>.   The first string of each row can be null in the data provided by Meta in their test framework, and the grids seem to be shifted on element to the right, which makes the expected result wrong on Meta's website.  Meta has been notified.

Solution l4_conveyor_chaos is provided but is hardcoded to return 0 for N > 200,000 the Kotlin solution seems too slow to run in the given time on Meta's website.
Solution for l3_rabbit_hole2 and l4_mathematical_art is missing so far.


<b><u>scala/*</u></b>

The solutions using Scala, "ported" from Kotlin as the syntax is similar.

Only 19 out 24 solutions are provided.  

Solution l2_rotary_lock2 is working on Meta's website, finishing in the given time, which suggest the Meta's Kotlin environment is an issue (both languages are using JVM, which is why this test was done in both languages: the JVM does not appear to be the issue).


<b><u>java/*</u></b>

The solutions using Java, "ported" from C++ as the syntax is (not that) similar.

Only 4 out 24 solutions are provided.  

Solution l2_rotary_lock2 is working on Meta's website, finishing in the given time, which suggest the Meta's Kotlin environment is an issue (both languages are using JVM, which is why this test was done in both languages: the JVM does not appear to be the issue).


----

## Notes

The solutions are  provided "as is". While the author is happy to provide reasonable assistance, there is no guarantee any assistance will be provided.
