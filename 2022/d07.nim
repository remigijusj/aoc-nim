# Advent of Code 2022 - Day 7

import std/[strutils,strscans,tables]
import ../utils/common

type Data = CountTable[seq[string]]


proc parseData: Data =
  var size: int
  var name: string
  var path: seq[string]

  for line in readInput().strip.splitLines:
    if line.scanf("$i $+", size, name):
      for x in 0..path.len:
        result.inc(path[0..<x], size)
    elif line == "$ cd /":
      discard
    elif line == "$ cd ..":
      discard path.pop
    elif line.scanf("$$ cd $+", name):
      path.add(name)


proc sumSmall(data: Data, lim: int): int =
  for size in data.values:
    if size < lim: result += size


proc findMin(data: Data, lim: int): int =
  result = int.high
  let used = data[@[]]

  for size in data.values:
    if used - size <= lim and size < result:
      result = size


let data = parseData()

benchmark:
  echo data.sumSmall(100000)
  echo data.findMin(40000000)
