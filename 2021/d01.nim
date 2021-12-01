# Advent of Code 2021 - Day 1

import std/[sequtils, strutils]

type Data = seq[int]


proc parseData(filename: string): Data =
  readFile(filename).strip.splitLines.mapIt(it.parseInt)


proc partOne(data: Data): int = zip(data, data[1..^1]).countIt(it[0] < it[1])
proc partTwo(data: Data): int = zip(data, data[3..^1]).countIt(it[0] < it[1])


let data = parseData("inputs/01.txt")
echo partOne(data)
echo partTwo(data)
