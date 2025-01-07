# Mathematical Art – solution explanation

The problem is composed of two separate problems:
* Create segments from input data
* Merging overlapping segments
* Counting crosses for the merged overlapping segments

## Merging overlapping segments sub-problem in O(n*log(n)):
The algorithm used is similar to the “[shadow volume](https://en.wikipedia.org/wiki/Shadow_volume)” algorithm in computer graphics.

Assuming horizontal segment (y, x0, x1) sharing the same y coordinate, where x0 < x1, the algorithm is as follow...

For each segment opening (x0), we assign a value of -1 -> (x0, -1).
For each segment closing (x1), we assign a value of +1 -> (x1, +1).
We create an array with those pairs, and we sorted it.

Parsing the area from left to right (smallest x to higher x), we accumulate the pairs’ second value:
* Any value below 0 means we have more opening than closing (we are inside a merge segment), and
* the value of 0 means we are outside a segment (so, we the value is zero, were store the merged segment).
* values above zero are not possible here

Without assuming anything on how the segments are built and assuming all segments are on the same line:
* Time Complexity: O(n*log(n))
* Space Complexity: O(n)

## Counting crosses for the merged overlapping segments in O(n<sup>2</sup>)
Assuming with have an array for vertical segments, and an array for horizontal segments (n elements at most).
A trivial algorithm in O(n<sup>2</sup>) would be for each vertical segments in O(n), test which horizontal segments are crossing in O(n).


In this case, the complexity is:
* Time Complexity: O(n*log(n))
* Space Complexity: O(1)

## Counting crosses for the merged overlapping segments in O(n*log(n))

<h3>The algorithm aims to be able to the following test:</h3>h3>
For a given vertical segment (x, y0, y1) where y0 < y1 (blue segment in the image below),
We have an ordered collection of horizontal segments (y[i], x0[i], x1[i]), sorted by y where x0[i] < x < x1[i] (red and green segment in the image below)

For an ordered set, we can use two binary search to find:
* which first horizontal segment crosses the vertical line (bottom green line), and
* which last horizontal segment crosses the vertical line (top green line)

It is important to not that while the ordered set enables an O(log(n)) fast insert/deletion/search of y values, usually, they do not provide a O(log(n)) distance function between elements.

For example, std::distance(iterator1, iterator2) in C++ will be O(n) (there is a gnu hack to do it in O(log(n)) in the source code provided).

It is possible to speed up distance function, by treating edge cases where one of the value in the min, or the max, or both.

![](./l4_mathematical_art1.png)

Should it be possible to maintain efficiently such an ordered set, we would have our log(n).

<h3>Algorithm used:</h3>

We are maintain data structure handling two set of strokes:
* vertical strokes (ver_strokes) V(x or hpos, y0, y1), representing a segment from (x, y0) to (x, y1)
* horizontal strokes (hor_strokes) V(y or vpos, x0, x1), representing a segment from (x0, y) to (x1, y)

The algorithm first choses the direction with the most lines (fixing N).
```
    if len(ver_strokes) > len(hor_strokes):
        ver_strokes, hor_strokes = hor_strokes, ver_strokes
```

The code now assumes this the direction of vertical strokes, which are sorted from the lowest x to the highest x, and we will iterate through those x values.
```
    for hpos, y0, y1 in ver_strokes:
```

We would like to be in a position where a log(n) search can be made to count all the horizontal segments that are crossing our vertical segments, i.e. lines such as: x0 < hpos < x1 and for such a subset of line, we would have the following:
* vpos <= y0 (no intersection)
* vpos >= y1 (no intersection)
* y0 < vpos < y1 (there is an intersection)

Using a red-black tree structure called "heights", we could calculate both the y0 and y1 to identify where the y0 and y1 coordinates for which the intersection (the second parameter equal to zero will be explained later)
```
        i = heights.bisect_right((y0, 0))
        j = heights.bisect_left((y1, 0))
```
However, we will need to calculated the "distance" between those y0 and y1 coordinates, which is calculated in term of indices to give the number of lines crosses
```
        nb += j - i
```
This distance needs to be calculate is O(log(n)) at most and not all language will provide an answer with this constraint (Python sortedcontainers will, G++ with some specific non-standard compiler flags will offer additional function to do so, and some a function using pure std call will optimise the search).

The only problem we are left with is to build heights fast enough. This will be done in functions add_heights and rem_heights in the main loop:
```
    for hpos, y0, y1 in ver_strokes:
        sp_in.add_heights(heights, hpos)
        sp_out.rem_heights(heights, hpos)
        i = heights.bisect_right((y0, 0))
        j = heights.bisect_left((y1, 0))
        nb += j - i
```

To add heights, for each value of hpos, we add points (vpos, x0) such as hpos > x0 ("in" points "opening" a segment), and this can be done in linear time if we use a sorted array and "opening/in" points called for horizontal strikes (sorted on (x0, h, x1)).

To remove heights, for each value of hpos, we remove points (vpos, x0) such as hpos <= x1 ("out" points "closing" a segment), and this can be done in linear time if we use a sorted array and "closing/out" points called for horizontal strikes (sorted on (x1, h, x0)).

The edge case is when we have multiple horizontal lines for a given hpos, and the tuple (vpos, x0) ensure the deletion of the correct segments. As segments cannot overlap, (vpos, x0) is unique.

While the parsing of horizontal in done with the loop over vertical stroke, for each of the horizontal strokes, parsing a stroke is done in O(1) add the insertion or deletion of our (vpos, v0) in "heights" is log(n), as we are using a red-black tree structure, therefore, the overall time complexity is O(n*log(n)).

Therefore, the overall complexity is:
* Time Complexity: O(n*log(n))
* Space Complexity: O(n)
