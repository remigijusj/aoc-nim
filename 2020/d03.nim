# Advent of code 2020 - Day 3

import std/strutils
import ../utils/common

type
  Slope = tuple[x, y: int]

  Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


proc countSlope(list: Data, s: Slope): int =
  var pos = 0
  for i in countUp(0, list.len-1, s.y):
    if list[i][pos mod list[i].len] == '#':
      result.inc
    pos.inc(s.x)


proc multCounts(list: Data, slopes: seq[Slope]): int =
  result = 1
  for s in slopes:
    result *= list.countSlope(s)


let data = parseData()

benchmark:
  echo data.countSlope((3, 1))
  echo data.multCounts(@[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)])
