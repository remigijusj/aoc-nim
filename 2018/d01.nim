# Advent of Code 2018 - Day 1

import std/[strutils,sequtils,sets]
import ../utils/common

type Data = seq[int]

proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.parseInt)


func sumSeenTwice(data: Data): int =
  var seen: HashSet[int]
  seen.incl(0)
  while true:
    for val in data:
      result += val
      if result in seen:
        return result
      seen.incl(result)


let data = parseData()

benchmark:
  echo data.sum
  echo data.sumSeenTwice
