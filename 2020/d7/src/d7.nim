import strutils, nre, sequtils

proc getInput*(num: uint): seq[string] =
  result = case num
    of 0: """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
      """.strip.splitLines
    of 1: """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
      """.strip.splitLines
    else: readFile("input.txt").strip.splitLines

proc parseBagContent*(content: string): (uint, string) =
  result = try:
    let num = parseUInt($content[0])
    let bagType = content[2..content.high]
    (num, bagType)
  except: (uint(1), content)

proc getBagContents*(bagDesc: string): seq[(uint, string)] =
  let regexp = re"(bag[s]?|contain|no other)[,.]*"
  result = bagDesc
    .strip
    .replace(regexp, "")
    .replace(re"\s{2,}", "|")
    .strip
    .split({'|'})
    .map(parseBagContent)

proc getBagDesc*(bag: string, bags: seq[string]): string =
  for desc in bags:
    if desc.continuesWith(bag, 0): return desc

proc traverseBagSum*(bag: (uint, string), bags: seq[string], acc: var uint): uint =
  ## Traverses down the bag untill there is no other bags inside
  
  # 1. Ищем bag строку в bags
  let bagDesc = getBagDesc(bag[1], bags)
  # 2. Достаем контент для bags[bag]
  var bagContents = getBagContents(bagDesc)
  bagContents = bagContents[1..bagContents.high]
  
  # var newAcc = acc
  for newBag in bagContents:
    # 3. Нашли shiny gold bag
    if newBag[1] == "shiny gold":
      if acc == 0: acc += 1
    # 4. Пустся сумка — возвращаемся
    if newBag[1] == "":
      return newBag[0] * bag[0]
    # 5. Рекурсивный вызов traverseBag, идем глубже
    result += traverseBagSum(newBag, bags, acc)

  result = result * bag[0] + bag[0]
  
