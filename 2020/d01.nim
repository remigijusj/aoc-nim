# Advent of code 2020 - Day 1

import std/[strutils, sequtils, algorithm]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  result = readInput().strip.splitLines.map(parseInt)
  result.sort


proc splitProduct2(list: Data, target: int): int =
  for i, x in list:
    if x >= target: break
    for y in list[i+1 .. ^1]:
      if x + y == target:
        return x * y


proc splitProduct3(list: Data, target: int): int =
  for i, x in list:
    if x >= target: break
    let y = splitProduct2(list[i+1 .. ^1], target - x)
    if y > 0:
      return x * y


let data = parseData()

benchmark:
  echo data.splitProduct2(2020)
  echo data.splitProduct3(2020)
