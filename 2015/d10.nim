# Advent of Code 2015 - Day 10

import std/[strutils]
from math import round
import ../utils/common


proc parseData: string =
  readInput().strip


func lookAndSay(data: string): string =
  let cap = round(data.len.float * 1.31).int
  result = newStringOfCap(cap)

  var digit = data[0]
  var count = 1
  for i in 1..<data.len:
    if data[i] == digit:
      count.inc
    else:
      result.add($count)
      result.add($digit)
      digit = data[i]
      count = 1
  result.add($count)
  result.add($digit)


proc extendTimes(data: var string, times: int): int =
  for i in 1..times:
    data = data.lookAndSay
  result = data.len


var data = parseData()

benchmark:
  echo data.extendTimes(40)
  echo data.extendTimes(10)
