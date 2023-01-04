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

The complete solutions are provided in following languages:
* Python (3): was developed first
* C\++(17): was developed second, but the code is written in a "plausible" medium developer style.

Mostly complete solutions are provided in the following languages (The code base will be updated soon with the solution missing)
* C# (7): based on C\++17
* Rust (1.66): based on C\++17

The intent is to use these solutions in a multi-language comparison, with additional languages (solution being written) such as Go, Swift, Scala, and Kotlin.

The idea is to evaluate which languages would be suitable to write strategies on a wide scale.  Rationale:  if you are working for a hedge fund (or a bank) and have people writing trading strategies, one might want to use a common language for that purpose.

A possible model is to use an easy language, such as Python, and "productionize" strategies with "real software developer".  Another strategy is to use a language easy to pick up, less likely to create problem (on a wide scale), offers good performances, and overall, provide a good value for money.

This first phase is about comparing basic language ecosystem needs, i.e. just the language with some basic collections.


----
## Files description


<u>py3/*</u>

The solutions in Python 3, all tested on Meta's website.
Written in my "quick and dirty" Python style.


<u>cpp17/*</u>

The solutions in C\++17, all tested on Meta's website.
C\++20 (or C\++23) would have helped making the code shorter and easier to read, but Meta's website is stuck in C\++17.

The code is written using a "plausible" medium developer style, and not much emphasis is spent on optimisation:
* it is intentional that, sometimes, shared_pointer are used when not needed (as it matches the Python's code and provides an additional opportunity for  benchmark).
* explicit int width: Meta seems to live in a meta  world where int is 32 bits, and long long is 64 bits.  int32_t/int64_t are used instead.
* l3_rabbit_hole2: iterative and recursive solutions are provided (could be interested for speed benchmark).
* l4_mathematical_art: for GCC, it can use "order_of_key" on std::set to match Python's code as std::distance in STL is linear on std::set, not logarithmic.


<u>cs/*</u>

The solutions in C#, ported from C++.
l4_conveyor_chaos and l4_mathematical_art are being reviewed.


<u>rs/*</u>

The solutions in Rust, "ported" from C++: the algorithms should be identical, but the code is written in a rustacean style.

A few solutions are missing for now, usually involving shared pointer (aka Rc in rust).  I am trying to find an elegant way to deal with them, using the latest stable Rust version (no overnight build).

----

## Notes

The solutions are  provided "as is". While the author is happy to reasonable
assistance, there is no guarantee any assistance will be provided.
