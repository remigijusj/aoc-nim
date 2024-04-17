# Advent of Code 2019 - Day 9

import std/[strutils, sequtils]
import intcode
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(",").mapIt(it.parseInt)


let data = parseData()

benchmark:
  echo data.runIntcode(1)
  echo data.runIntcode(2)
