# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

const test_input =
  """
abc

a
b
c

ab
ac
a

a
a
a
a

b
  """

const input = slurp("input.txt")

import d6

test "can get uniq answers":
  check uniqAnswers(test_input) == @["abc", "abc", "abc" , "a", "b"]

test "can get grouped answers":
  check groupedAnswers(test_input) == @[@["abc"], @["a", "b", "c"], @["ab", "ac", "a"] , @["a", "a", "a", "a"], @["b"]]

test "can count uniq answers":
  check countAnswers(uniqAnswers(test_input)) == 11

test "can count grouped answers":
  check countGroupedAnswers(groupedAnswers(test_input)) == 6

test "solve part 1":
  check true
  echo countAnswers(uniqAnswers(input)) 

test "solve part 2":
  check true
  echo countGroupedAnswers(groupedAnswers(input)) 

