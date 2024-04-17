# Advent of code 2020 - Day 10

import std/[strutils, sequtils, algorithm]
import ../utils/common

type Data = seq[int]


# also inserted 0 at head, max+3 at tail
proc parseData: Data =
  result = readInput().strip.splitLines.map(parseInt)
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


let data = parseData()

benchmark:
  echo data.tallyDiffs.withIt(it[1] * it[3])
  echo data.oneChains.mapIt(it.tribonacci).prod
