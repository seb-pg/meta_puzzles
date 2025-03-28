# meta_puzzles by Sebastien Rubens
#
# Please go to https://github.com/seb-pg/meta_puzzles/README.md
# for more information
#
# To the extent possible under law, the person who associated CC0 with
# meta_puzzles has waived all copyright and related or neighboring rights
# to meta_puzzles.
#
# You should have received a copy of the CC0 legalcode along with this
# work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

from typing import Any, List, Tuple
from sortedcontainers import SortedSet


def read_strokes(N: int, L: List[int], D: str) -> Tuple[List[Tuple[int, int, int]], List[Tuple[int, int, int]]]:
    # O(N)
    hor_strokes, ver_strokes = [], []
    x0, y0 = 0, 0
    for length, direction in zip(L[:N], D[:N]):
        if direction == 'R':
            x1, y1 = x0 + length, y0
            hor_strokes.append((y0, x0, x1))
        elif direction == 'L':
            x1, y1 = x0 - length, y0
            hor_strokes.append((y0, x1, x0))
        elif direction == 'U':
            x1, y1 = x0, y0 + length
            ver_strokes.append((x0, y0, y1))
        elif direction == 'D':
            x1, y1 = x0, y0 - length
            ver_strokes.append((x0, y1, y0))
        else:
            raise NotImplementedError("direction '%s' is not processed" % direction)
        x0, y0 = x1, y1
    return hor_strokes, ver_strokes


def convert_strokes(strokes: List[Tuple[int, int, int]]) -> List[Tuple[int, int, int]]:
    # O(N)
    return [(fixed, start, -1) for fixed, start, _ in strokes] + [(fixed, end, +1) for fixed, _, end in strokes]


def merge_strokes(strokes):
    # Complexity: O(N)
    if not strokes:
        return []
    # naming is set to deal with vertical strokes (same code for horizontal strokes)
    i = 0
    x0, y0, total = strokes[0]  # first point
    for x1, y1, inc in strokes[1:]:
        if x0 != x1:  # if we change x
            x0, y0, total = x1, y1, inc  # we reset x0, y0 and total
            continue
        if total == 0:
            y0 = y1
        total += inc
        if total == 0:  # if we end an interval
            strokes[i] = x0, y0, y1
            i += 1
            # we need to reset x0 here!
    return strokes[:i]


def count_crosses(ver_strokes, hor_strokes):
    # Complexity: O(N*log(N))

    class StrokeProcessor:

        def __init__(self, strokes):
            self.strokes = strokes
            self.idx = 0
            self.len = len(strokes)
            return

        def add_heights(self, heights, hpos):
            while self.idx < self.len:
                x0, vpos, x1 = self.strokes[self.idx]
                if hpos <= x0:
                    break
                heights.add((vpos, x0))
                self.idx += 1
            return

        def rem_heights(self, heights, hpos):
            while self.idx < self.len:
                x1, vpos, x0 = self.strokes[self.idx]
                if hpos < x1:
                    break
                heights.remove((vpos, x0))
                self.idx += 1
            return

    # trivial optimisation
    if len(hor_strokes) == 0 or len(ver_strokes) == 0:
        return 0

    # ver_strokes is chosen to be the smallest container
    # the reason is we will iterate over ver_strokes, while we will use log-time operation on hor_strokes
    if len(ver_strokes) > len(hor_strokes):
        ver_strokes, hor_strokes = hor_strokes, ver_strokes

    # we need to create a list of height to insert (we cannot have consecutive x's for a given height)
    # O(n*log(N))
    hor_strokes_in = sorted((x0, h, x1) for h, x0, x1 in hor_strokes)  # O(N*log(N))
    hor_strokes_out = sorted((x1, h, x0) for h, x0, x1 in hor_strokes)  # O(N*log(N))

    # count crosses
    sp_in = StrokeProcessor(hor_strokes_in)
    sp_out = StrokeProcessor(hor_strokes_out)
    nb = 0
    heights = SortedSet()

    # add heights before the first hpos
    for hpos, y0, y1 in ver_strokes:  # N iterations
        sp_in.add_heights(heights, hpos)  # log(N)  (at most N times over the N iterations)
        sp_out.rem_heights(heights, hpos)  # log(N)  (at most N times over the N iterations)
        i = heights.bisect_right((y0, 0))  # log(N), index of first point strictly greater than y0
        j = heights.bisect_left((y1, 0))  # log(N), index of first point slower greater than y1 (+1)
        nb += j - i
    return nb


def getPlusSignCountCommon(hor_strokes: List[Tuple[int, int, int]], ver_strokes: List[Tuple[int, int, int]]) -> int:
    if len(hor_strokes) == 0 or len(ver_strokes) == 0:
        return 0

    # O(N*log(N))
    hor_strokes.sort()
    ver_strokes.sort()

    # O(N)
    hor_strokes = merge_strokes(hor_strokes)
    ver_strokes = merge_strokes(ver_strokes)

    #
    if False and (len(hor_strokes) + len(ver_strokes) < 20):
        for y, x0, x1 in hor_strokes:
            plt.plot([x0, x1], [y, y], marker='o')
        for x, y0, y1 in ver_strokes:
            plt.plot([x, x], [y0, y1], marker='o')
        plt.show()

    # O(N*log(N))
    nb = count_crosses(ver_strokes, hor_strokes)
    return nb


def getPlusSignCount(N: int, L: List[int], D: str) -> int:
    # https://www.metacareers.com/profile/coding_puzzles/?puzzle=587690079288608
    # Constraints:
    #   2 <= N <= 2,000
    #   1 <= Li <= 1,000,000,000
    #   Di ∈ {U, D, L, R}
    # Complexity: O(N*log(N))
    hor_strokes, ver_strokes = read_strokes(N, L, D)
    hor_strokes = convert_strokes(hor_strokes)
    ver_strokes = convert_strokes(ver_strokes)
    return getPlusSignCountCommon(hor_strokes, ver_strokes)


def getPlusSignCountEx(hor_strokes, ver_strokes) -> int:
    if isinstance(ver_strokes, str):
        L, D = hor_strokes, ver_strokes
        return getPlusSignCount(len(L), L, D)
    hor_strokes = convert_strokes(hor_strokes)
    ver_strokes = convert_strokes(ver_strokes)
    return getPlusSignCountCommon(hor_strokes, ver_strokes)


def build_test(test=None, N=2_000_000):
    import random
    Lmin, Lmax = 1, 1_000_000_000
    # Lmid = (Lmax - Lmin) // 2
    if test == 'hline':
        # horizontal line
        random.seed(12345)
        L, D = [], []
        src = 0
        while len(D) < N:
            dst = random.randint(1, Lmax)
            if src < dst:
                D.append('R')
                L.append(dst - src)
            elif src > dst:
                D.append('L')
                L.append(src - dst)
            src = dst
        cases = ((L, D), 0)
    elif test == 'hsnake':
        # infinite snake
        D, L = [], []
        directions = 'RURD'
        for i in range(N):
            D.append(directions[i % 4])
            L.append(1)
        cases = ((L, D), 0)
    elif test in ['grid', 'grid2']:
        # grid
        n = (N + 7) // 8
        inc = 1 if test == 'grid2' else 0
        D = 'RULU' * n + 'RDRU' * n
        L = []
        w = n * 2 + 1
        for i in range(n):
            L.append(w)
            L.append(1)
            w += inc
            L.append(w)
            L.append(1)
            w += inc
        w = n * 2 + 1
        for i in range(n):
            L.append(1)
            L.append(w)
            w += inc
            L.append(1)
            L.append(w)
            w += inc
        if test == 'grid2':
            L[n * 4] = n + 1  # reset this one
        expected = (2 * n) ** 2
        cases = ((L, D), expected)
    elif test == 'spiral':
        # spiral with no intersect
        D, L = [], []
        l, directions = 0, 'RULD'
        for i in range(N):
            if i % 2 == 0:
                l += 1
            D.append(directions[i % 4])
            L.append(l)
        cases = ((L, D), 0)
    else:
        cases = []
    return cases


def tests():
    def fn(*args): return args
    meta_cases = "meta", [
        (([6, 3, 4, 5, 1, 6, 3, 3, 4], "ULDRULURD", ), 4),
        (([1, 1, 1, 1, 1, 1, 1, 1], "RDLUULDR", ), 1),
        (([1, 2, 2, 1, 1, 2, 2, 1], "UDUDLRLR", ), 1),
    ]
    extra1_cases = "extra1", [
        (([1, 1, 1, 1, 1, 1], "RDURLU", ), 1),
        (([1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1], "ULRUDRULUDLRD ",), 2),
        (([1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1], "RDURLURDLRDUR",), 2),
        (([(0, 0, 2), (0, 3, 4), (0, 6, 7), (0, 8, 10)], [(1, -1, 1), (9, -1, 1)]), 2),
        (([(0, 0, 2), (0, 3, 4), (0, 6, 7), (0, 8, 10)], [(1, -1, 1), (8, -1, 1)]), 1),
        (([(0, 0, 2), (0, 3, 4), (0, 6, 7), (0, 8, 10)], [(0, -1, 1), (9, -1, 1)]), 1),
        (([(0, 0, 2), (0, 3, 4), (0, 6, 7), (0, 8, 10)], [(2, -1, 1), (8, -1, 1)]), 0),
        (([(1, -1, 1), (8, -1, 1)], [(0, 0, 2), (0, 3, 4), (0, 5, 6), (0, 7, 9)]), 2),
        build_test('grid', 100_000),
    ]

    return getPlusSignCountEx, fn, [meta_cases, extra1_cases]


# End
