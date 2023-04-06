# Advent of Code 2018 - Day 1

import std/[strutils,sequtils,sugar,sets]

type Data = seq[int]

proc parseData: Data =
  readAll(stdin).strip.splitLines.mapIt(it.parseInt)


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

let part1 = data.foldl(a + b)
let part2 = data.sumSeenTwice

echo part1
echo part2
