# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import strutils, sequtils

when isMainModule:
  #let input = 
  #  """
  #  ..##.........##.........##.........##.........##.........##.......  --->
  #  #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
  #  .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
  #  ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
  #  .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
  #  ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
  #  .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
  #  .#........#.#........#.#........#.#........#.#........#.#........#
  #  #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
  #  #...##....##...##....##...##....##...##....##...##....##...##....#
  #  .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
  #  """
  const input = "./input.txt"

  var pos = 0
  var delta = 3
  var trees = 0

  for line in input.readFile.strip.splitLines: #[input.strip.splitLines:]#
    if pos mod line.high != 0:
      pos = pos mod line.len
    
    if line[pos] == '#':
      inc(trees)

    pos += delta
