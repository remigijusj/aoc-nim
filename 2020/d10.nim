# Advent of code 2020 - Day 10

import sequtils
from strutils import parseInt
from algorithm import sort

# also inserted 0 at head, max+3 at tail
proc sortedIntList(filename: string): seq[int] =
  for line in lines(filename):
    result.add parseInt(line)

  result.sort
  result.insert(0, 0)
  result.add(result[^1] + 3)


proc tallyDiffs(list: seq[int]): array[4, int] =
  for (a, b) in list.zip(list[1..^1]):
    result[b-a].inc


# consecutive chains of 1-diffs
proc oneChains(list: seq[int]): seq[int] =
  var s = 0
  for (a, b) in list.zip(list[1..^1]):
    case b-a:
    of 1: s.inc
    of 3:
      if s > 0:
        result.add(s)
        s = 0
    else:
      raise newException(AssertionDefect, "diff is no 1 or 3")


# start of the sequence, cached values, see https://oeis.org/A000073
proc tribonacci(n: int): int =
  [1, 1, 2, 4, 7][n]


template withIt(val, op: untyped): untyped =
  let it {.inject.} = val
  op


proc partOne(list: seq[int]): int = list.tallyDiffs.withIt(it[1] * it[3])
proc partTwo(list: seq[int]): int = list.oneChains.mapIt(it.tribonacci).foldl(a * b)


let list = sortedIntList("inputs/10.txt")
echo partOne(list)
echo partTwo(list)
