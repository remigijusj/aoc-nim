# Advent of Code 2023 - Day 9

import std/[strutils,sequtils,algorithm]
import ../utils/common

type
  List = seq[int]

  Data = seq[List]


proc parseData: Data =
  readAll(stdin).strip.splitLines.mapIt(it.splitWhitespace.map(parseInt))


func predictNext(list: List): int =
  if list.allIt(it == 0):
    return 0

  var diff: List
  for i in 1..<list.len:
    diff.add(list[i] - list[i-1])

  result = list[^1] + diff.predictNext


let data = parseData()

benchmark:
  echo data.mapIt(it.predictNext).sum
  echo data.mapIt(it.reversed.predictNext).sum
