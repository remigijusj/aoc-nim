# Advent of Code 2016 - Day 19

import std/[strutils]
import ../utils/common

proc parseData: int =
  readInput().strip.parseInt


func findLast1(n: int): int =
  var pos = 0
  for i in 2..n:
    pos = (pos + 2) mod i
  result = pos + 1


# i-1 ternary high digit is 1 and rest are not all 0
func one(i: int): bool =
  var t = i-1
  var z = true
  while t >= 3:
    if t mod 3 != 0:
      z = false
    t = t div 3
  result = (t == 1 and not z)


func findLast2(n: int): int =
  var pos = 0
  for i in 2..n:
    let k = if one(i): 1 else: 2
    pos = (pos + k) mod i
  result = pos + 1


let data = parseData()

benchmark:
  echo data.findLast1
  echo data.findLast2
