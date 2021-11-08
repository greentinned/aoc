# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.
import strutils, sequtils

proc uniqAnswers*(input: string): seq[string] =
  ## Parses given input and returns array of w/o chars dup
  for line in input.strip.split("\n\n"):
    let jl = line.strip.splitLines.join.deduplicate.join
    result.add(jl)

proc groupedAnswers*(input: string): seq[seq[string]] =
  ## Parses given input and returns array of 'groups'
  for line in input.strip.split("\n\n"):
    let gl = line.split("\n")
    result.add(gl)

proc countAnswers*(answers: seq[string]): uint =
  result = uint(answers.map(proc(q: string): int = q.len).foldl(a + b))

proc countGroupedAnswers*(answers: seq[seq[string]]): uint =
  for group in answers:
    if group.len == 1:
      result += uint(group.join.len)
    else:
      let joined_answers = group.join.strip
      let deduped_answers = joined_answers.deduplicate
      for answer in deduped_answers:
        let count = joined_answers.count(answer)
        if count == group.len:
          result += 1
