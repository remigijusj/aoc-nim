# Advent of Code 2021 - Day 24

import std/[strutils, sequtils]

type
  Triplet = seq[int]

  Data = seq[Triplet]


proc parseTriplet(lines: seq[string]): Triplet =
  [4, 5, 15].mapIt(lines[it].split(" ")[^1].parseInt)


proc parseData(filename: string): Data =
  lines(filename).toSeq.distribute(14).map(parseTriplet)


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


proc partOne(data: Data): string = data.validRanges.mapIt(it.max).join
proc partTwo(data: Data): string = data.validRanges.mapIt(it.min).join


let data = parseData("inputs/24.txt")
echo partOne(data)
echo partTwo(data)
