# Advent of Code 2021 - Day 6

import std/[strutils, sequtils, algorithm]
import ../utils/common

type
  Data = seq[int]

  Distrib = array[9, int]


proc parseData: Data =
  readInput().strip.split(",").mapIt(it.parseInt)


proc tally(list: Data): Distrib =
  for it in list:
    result[it].inc


proc simulateFish(data: Data, days: int): Distrib =
  result = data.tally
  for day in countup(1, days):
    result.rotateLeft(1)
    result[6] += result[8]


let data = parseData()

benchmark:
  echo data.simulateFish(80).sum
  echo data.simulateFish(256).sum
