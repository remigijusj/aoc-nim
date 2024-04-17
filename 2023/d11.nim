# Advent of Code 2023 - Day 11

import std/[strutils,sequtils,algorithm,packedsets]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[XY]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for y, line in lines:
    for x, c in line:
      if c == '#':
        result.add (x, y)


proc distsum(list: seq[int], expand: int): int =
  var list = list.sorted
  var gaps = toSeq(list[0]..list[^1]).toPackedSet - list.toPackedSet
  for j in 1..<list.len:
    for i in 0..<j:
      result += list[j] - list[i]
      for k in list[i]..<list[j]:
        if k in gaps:
          result += expand-1


proc distsum(data: Data, expand: int): int =
  data.mapIt(it.x).distsum(expand) + data.mapIt(it.y).distsum(expand)


let data = parseData()

benchmark:
  echo data.distsum(2)
  echo data.distsum(1000_000)
