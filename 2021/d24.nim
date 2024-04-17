# Advent of Code 2021 - Day 24

import std/[strutils, sequtils]
import ../utils/common

type
  Triplet = seq[int]

  Data = seq[Triplet]


proc parseTriplet(lines: seq[string]): Triplet =
  [4, 5, 15].mapIt(lines[it].split(" ")[^1].parseInt)


proc parseData: Data =
  readInput().strip.splitLines.distribute(14).map(parseTriplet)


proc validRanges(data: Data): array[14, tuple[min, max: int]] =
  var zstack: seq[int]
  for i, d in data:
    if d[0] == 1:
      zstack.add(i)
      continue

    let j = zstack.pop
    let e = data[j]
    let sum = d[1] + e[2]

    if sum > 0:
      result[i] = (1 + sum, 9)
      result[j] = (1, 9 - sum)
    else:
      result[i] = (1, 9 + sum)
      result[j] = (1 - sum, 9)


let data = parseData()

benchmark:
  echo data.validRanges.mapIt(it.max).join
  echo data.validRanges.mapIt(it.min).join
