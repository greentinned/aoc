import unittest

import d7

test "get bag description":
  var input = getInput(0)
  check  getBagDesc("shiny gold", input) == "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags."

test "get bag contents":
  check  getBagContents(
    "light red bags contain 1 bright white bag, 2 muted yellow bags."
  ) == @[(uint(1), "light red"), (uint(1), "bright white"), (uint(2), "muted yellow")] 


test "solve part 1":
  const bagsDesc = getInput(0)
  var total: uint

  for bagDesc in bagsDesc:
    let bag = getBagContents(bagDesc)[0]
    var count: uint
    discard traverseBagSum(bag, bagsDesc, count)
    total += count

  check total == 4

test "solve part 2":
  const bagsDesc = getInput(2)
  var count: uint = 0
  let goldBag = getBagContents(getBagDesc("shiny gold", bagsDesc))[0]
  count = traverseBagSum(goldBag, bagsDesc, count)
  echo count - 1
  check true


