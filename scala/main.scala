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

@main
def main(): Unit = {
    var nb_errors: Int = 0
    // l0
    nb_errors += l0_abcs.Solution.tests()
    nb_errors += l0_all_wrong.Solution.tests()
    nb_errors += l0_battleship.Solution.tests()
    // l2
    nb_errors += l2_rotary_lock2.Solution.tests()
    println("\n" + nb_errors + " errors found")
}
