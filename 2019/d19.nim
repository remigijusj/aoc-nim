# Advent of Code 2019 - Day 19

import std/[strutils,sequtils]
import intcode
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


proc partOne(data: Data): int =
  for y in 0..49:
    for x in 0..49:
      result.inc data.runIntcode(x, y)


proc partTwo(data: Data): int =
  var (x, y) = (0, 1)
  while data.runIntCode(x+99, y) == 0:
    y.inc
    while data.runIntCode(x, y+99) == 0:
      x.inc
  result = x * 10000 + y


let data = parseData()

benchmark:
  echo data.partOne
  echo data.partTwo
