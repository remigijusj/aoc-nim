# Advent of Code 2022 - Day 6

import std/[strutils,setutils]
import ../utils/common

proc findDistinct(data: string, n: int): int =
  for i, _ in data:
    if data[i..<(i+n)].toSet.card == n:
      return i+n


let data = readInput().strip

benchmark:
  echo data.findDistinct(4)
  echo data.findDistinct(14)
