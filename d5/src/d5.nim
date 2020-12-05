# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import strutils, sequtils, math

proc getInput(file: bool): seq[string] =
  if file: return readFile("input.txt").strip.splitLines
  result = @["FBFBBFFRLR"]


proc lowerHalf(input: seq[int]): seq[int] =
  let
      n = input[input.low]
      m = input[input.high]
  result = @[n, int(((m - n) / 2).floor) + n]

proc upperHalf(input: seq[int]): seq[int] =
  let
      n = input[input.low]
      m = input[input.high]
  result = @[int(((m - n) / 2).ceil) + n, m]

when isMainModule:
  let
    input = getInput(false)

  var
    seatRow = @[0, 127]
    seatCol = @[0, 7]

  for seat in input:
    var i: int
    while i < seat.len:
      case seat[i]
      # Lower half
      of 'F':
        seatRow = lowerHalf(seatRow)
      # Upper half
      of 'B':
        seatRow = upperHalf(seatRow)
      # Lower half
      of 'L':
        seatCol = lowerHalf(seatCol)
      # Upper half
      of 'R':
        seatCol = upperHalf(seatCol)
      else: discard
      echo seat[i], ":", seatRow, ":", seatCol
      inc(i)
  echo seatRow[0] * 8 + seatCol[0]

