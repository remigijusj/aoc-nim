# Advent of Code 2021 - Day 1

import std/[sequtils, strutils]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.parseInt)


let data = parseData()

benchmark:
  echo zip(data, data[1..^1]).countIt(it[0] < it[1])
  echo zip(data, data[3..^1]).countIt(it[0] < it[1])
