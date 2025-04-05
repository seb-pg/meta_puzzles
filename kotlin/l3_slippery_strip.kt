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

package l3_slippery_strip

class Counts(
    var star: Int,
    var right: Int,
    var down: Int)

typealias row_t = ArrayList<Char>;
typealias char_counter_t = ArrayList<Int>;

fun get_counts(row: Array<Char>, counts: char_counter_t): Counts
{
    counts['*'.code] = 0;
    counts['>'.code] = 0;
    counts['v'.code] = 0;
    for (c in row)
    {
        var d = c.code;
        if (d >= counts.size)
            d = '.'.code;  // empty value (we do not use it)
        ++counts[d];
    }
    return Counts(counts['*'.code], counts['>'.code], counts['v'.code])
}

fun get_nb_coins_right_then_down3(row: Array<Char>, _count_down: Int, _count_right: Int): Int
{
    // complexity : O(C)
    if (_count_down == 0)
        return 0;
    val k = row.indexOf('v');
    val j = if (k != -1) (k + 1) else 0;
    val new_row = row_t();
    new_row.addAll(row.slice(j until row.size));
    new_row.addAll(new_row.size, row.slice(0 until j));
    var count_down = _count_down;
    var count_right = _count_right;
    var nb_coins_right_then_down = 0;
    val size = new_row.size;
    var last = 0;
    while (count_right * count_down != 0)
    {
        val first = new_row.slice(last until size).indexOf('>') + last;
        last = new_row.slice(first until size).indexOf('v') + 1 + first;
        nb_coins_right_then_down = maxOf(nb_coins_right_then_down, new_row.slice(first until last).count() {it == '*'}.toInt())
        count_down -= 1;
        count_right -= new_row.slice(first until last).count() { it == '>' }.toInt();
    }
    return nb_coins_right_then_down;
}

fun _getMaxCollectableCoins(R: Int, C: Int, G: Array<Array<Char>>): Int {
    val counts = char_counter_t(256);
    repeat(256) { index -> counts.add(0) }
    var res = 0;
    for (i in 0 until G.size)
    {
        val row = G[G.size - i - 1];
        val count = get_counts(row, counts);
        val nb_coins_immediately_down = minOf(count.star, 1);
        if (count.right == C.toInt())
            res = 0;
        else if (count.right == 0)
            res += nb_coins_immediately_down;
        else
        {
            val nb_coins_right_then_down = get_nb_coins_right_then_down3(row, count.down, count.right);
            val nb_coins_right_forever = if (count.down == 0) count.star else 0;
            res = maxOf(nb_coins_immediately_down + res, maxOf(nb_coins_right_then_down + res, nb_coins_right_forever));
        }
    }
    return res.toInt();  // result should always be positive
}

fun getMaxCollectableCoins(R: Int, C: Int, G: Array<Array<String>>): Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=2881982598796847
    // Constraints
    //      2 ≤ R, C ≤ 400, 000
    //      R∗C ≤ 800, 000
    //      Gi, j ∈{ ".", "*", ">", "v" }
    //      Complexity: O(N), where N = R * C

    val H = ArrayList<Array<Char>>(G.size);
    for (in_row in G)
    {
        val row = ArrayList<Char>(in_row.size);
        for (c in in_row)
            row.add(if (!c.isEmpty()) c[0] else '.');  // FIXME: Meta's website provide corrupted test data!
        H.add(row.toTypedArray());
    }
    return _getMaxCollectableCoins(H.size, if (H.isEmpty()) 0 else H[0].size, H.toTypedArray());
}

fun _getMaxCollectableCoinsTest(G: Array<String>): Int {
    val H = ArrayList<Array<String>>(G.size);
    for (in_row in G)
    {
        val row = ArrayList<String>(in_row.length);
        for (c in in_row)
            row.add(c.toString());
        H.add(row.toTypedArray());
    }
    return getMaxCollectableCoins(H.size, if (H.isEmpty()) 0 else H[0].size, H.toTypedArray());
}

class Args(
    val G: Array<String>,
    val res: Int) : test.Result<Int> {
    override fun get_result(): Int { return res; };
}

fun tests(): Int
{
    val wrapper = { p: Args -> _getMaxCollectableCoinsTest(p.G) };

    val args_list: List<Args> = listOf(
        Args( arrayOf(".***", "**v>", ".*.."), 4 ),
        Args( arrayOf(">**", "*>*", "**>"), 4 ),
        Args( arrayOf(">>", "**"), 0 ),
        Args( arrayOf(">*v*>*", "*v*v>*", ".*>..*", ".*..*v"), 6 ),
        // extra1
        Args( arrayOf<String>(), 0 ),
        Args( arrayOf("."), 0 ),
        Args( arrayOf("v"), 0 ),
        Args( arrayOf(">"), 0 ),
        Args( arrayOf("*"), 1 ),
        // extra2
        Args( arrayOf(".", ".", ">", "*"), 0 ),
        Args( arrayOf(".", "*", ">", "*"), 1 ),
        Args( arrayOf(".", "*", ">", "."), 1 ),
        Args( arrayOf("*", ".", ">", "."), 1 ),
        Args( arrayOf("***", "...", ">vv", "..."), 1 ),
        // extra3
        Args( arrayOf("*....", ".*...", "..*..", "...*."), 4 ),
        Args( arrayOf("....", "....", "....", "...."), 0 ),
        Args( arrayOf("***>", "...."), 3 ),
        Args( arrayOf("*"), 1 ),
        Args( arrayOf("vvvv"), 0 ),
        Args( arrayOf("vvvv", "....", ">>>>"), 0 ),
        // extra4
        Args( arrayOf("******", "......", ">*>vvv", "......"), 2 ),
        Args( arrayOf("*****", ".....", ">>vvv", "....."), 1 )
    );

    return test.run_all_tests("l3_slippery_strip", args_list, wrapper);
}
