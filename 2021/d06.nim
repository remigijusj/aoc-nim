# Advent of Code 2021 - Day 6

import std/[strutils, sequtils, algorithm]

type
  Data = seq[int]

  Distrib = array[9, int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").mapIt(it.parseInt)


proc tally(list: Data): Distrib =
  for it in list:
    result[it].inc


proc simulateFish(data: Data, days: int): Distrib =
  result = data.tally
  for day in countup(1, days):
    result.rotateLeft(1)
    result[6] += result[8]


proc partOne(data: Data): int = data.simulateFish(80).foldl(a + b)
proc partTwo(data: Data): int = data.simulateFish(256).foldl(a + b)


let data = parseData("inputs/06.txt")
echo partOne(data)
echo partTwo(data)
