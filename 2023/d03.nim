# Advent of Code 2023 - Day 3

import std/[strutils,nre,tables]
import ../utils/common

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Parts = seq[int]

  Gears = Table[XY, seq[int]]


proc parseData: Data =
  readInput().strip.splitLines


proc scanParts(data: Data): (Parts, Gears) =
  for li, line in data:
    for rm in line.findIter(re"\d+"):
      let number = parseInt($rm)
      var symbol = false
      # scan surroundings
      for ri in max(0, li-1)..min(li+1, data.len-1):
        for sm in data[ri].findIter(re"[^.0-9]", max(0, rm.matchBounds.a-1), min(rm.matchBounds.b+1, line.len-1)):
          symbol = true
          if $sm == "*":
            let gear = (sm.matchBounds.a, ri)
            discard result[1].hasKeyOrPut(gear, @[])
            result[1][gear].add(number)
      if symbol:
        result[0].add number


func sumRatios(gears: Gears): int =
  for list in gears.values:
    if list.len == 2:
      result += list[0] * list[1]


let data = parseData()

benchmark:
  let (parts, gears) = data.scanParts
  echo parts.sum
  echo gears.sumRatios
