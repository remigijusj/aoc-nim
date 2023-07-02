# Advent of Code 2017 - Day 5

import std/[strutils,sequtils]

type Data = seq[int]


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInt)


func stepsToExit(data: Data, flip = false): int =
  var data = data
  var this = 0
  while this in 0..<data.len:
    result.inc
    let next = this + data[this]
    if flip and data[this] >= 3:
      data[this].dec
    else:
      data[this].inc
    this = next


let data = parseData()

echo data.stepsToExit
echo data.stepsToExit(true)
