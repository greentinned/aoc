# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import strutils
import sequtils

when isMainModule:
  let f = readFile("./input.txt")
  let  input = f.strip.splitLines.map(parseInt)

  block loop:
    for a in input:
      for b in input:
        for c in input:
          if a + b + c == 2020:
            echo a * b * c
            break loop
