# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import strutils

proc getInput(file: bool): seq[string] =
  if file: return readFile("input.txt").strip.splitLines

  result = 
    """
..##.........##.........##.........##.........##.........##.......
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#
    """.strip.splitLines


when isMainModule:
  var result = 1

  const slopes = @[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

  for slope in slopes:
    var li, pos, trees: int

    for line in getInput(true):
      if pos mod line.high != 0:
        pos = pos mod line.len

      if li mod slope[1] == 0:
        if line[pos] == '#': inc(trees)
        pos += slope[0]

      inc(li)

    result *= trees

  echo result
