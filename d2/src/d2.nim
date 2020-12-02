import strutils
import sequtils

# Part One

proc test(rule: string): uint =
  let parts = rule.strip.splitWhitespace()

  let minMax = parts[0]
  let min = ($minMax.split('-')[0]).parseInt
  let max = ($minMax.split('-')[1]).parseInt

  let letter = parts[1][0]
  let count = parts[2].count(letter)
  
  if min <= count and count <= max:
    result = 1 
  else:
    result = 0

# Part Two

proc test2(rule: string): uint =
  let parts = rule.strip.splitWhitespace()

  let minMax = parts[0]
  let min = ($minMax.split('-')[0]).parseInt - 1
  let max = ($minMax.split('-')[1]).parseInt - 1

  let letter = parts[1][0]
  let firstMatch = parts[2][min] == letter
  let secondMatch = parts[2][max] == letter
  
  if firstMatch and not secondMatch:
    result = 1 
  elif not firstMatch and secondMatch:
    result = 1
  else:
    result = 0

when isMainModule:
  let input = readFile("input.txt").strip.splitLines
  echo input.map(test2).foldl(a + b)

