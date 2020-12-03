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
  var pos = 0
  var li = 0
  var trees = 0
  var treesMul = 1

  const rules = @[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
  
  for rule in rules:
    li = 0
    pos = 0
    trees = 0

    echo "\nrule: ", rule

    for line in getInput(true):
      var lineDesc = line

      if pos mod line.high != 0:
        pos = pos mod line.len

      if li mod rule[1] == 0:
        lineDesc[pos] = 'O'

        if line[pos] == '#':
          lineDesc[pos] = 'X'
          inc(trees)

        pos += rule[0]

      echo "li: ", li, "\t line: ", lineDesc, "\ttrees: ", trees
      inc li

    treesMul *= trees

  echo "\ntrees multiplied: ", treesMul
