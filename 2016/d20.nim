# Advent of Code 2016 - Day 20

import std/[strutils,sequtils,algorithm]
import ../utils/common

type
  Interval = Slice[int]

  Data = seq[Interval]


func parseInterval(line: string): Interval =
  let parts = line.split("-").map(parseInt)
  assert parts[0] <= parts[1]
  result = parts[0]..parts[1]


proc parseData: Data =
  readInput().strip.splitLines.map(parseInterval)


proc `<`(x, y: Interval): bool {.inline.} =
  if x.a == y.a:
    x.b < y.b
  else:
    x.a < y.a


proc consolidate(data: Data): Data =
  result.add data[0]
  for this in data[1..^1]:
    let prev = result[^1]
    if this.a <= prev.b + 1:
      result[^1].b = max(prev.b, this.b)
    else:
      result.add this


func minAllowed(data: Data): int =
  for i in data:
    assert i.a == 0
    return i.b + 1


func countAllowed(data: Data): int =
  for i in data:
    result += i.len
  result = uint32.high.int - result + 1


var data = parseData()
data.sort()
let list = data.consolidate

benchmark:
  echo list.minAllowed
  echo list.countAllowed
