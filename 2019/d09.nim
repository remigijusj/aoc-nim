# Advent of Code 2019 - Day 9

import std/[strutils, sequtils], intcode

type Data = seq[int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").mapIt(it.parseInt)


proc partOne(data: Data): int = runIntcode(data, 1)
proc partTwo(data: Data): int = runIntcode(data, 2)

let data = parseData("inputs/09.txt")
echo partOne(data)
echo partTwo(data)
