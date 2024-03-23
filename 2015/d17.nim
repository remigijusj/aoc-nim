# Advent of Code 2015 - Day 17

import std/[strutils,sequtils,tables,algorithm]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInt)


iterator combinations(data: Data, size, this, used: int): int {.closure.} =
  let left = data[this..^1].sum
  if size < 0 or left < size:
    return
  if left == size or left == 0:
    yield used + (data.len - this)
    return
  for x in data.combinations(size, this + 1, used):
    yield x
  for x in data.combinations(size - data[this], this + 1, used + 1):
    yield x


func countCombinations1(data: Data, size: int): int =
  for _ in data.combinations(size, 0, 0):
    result.inc


func countCombinations2(data: Data, size: int): int =
  var groups: CountTable[int]
  for pieces in data.combinations(size, 0, 0):
    groups.inc(pieces)
  let smallest = groups.keys.toSeq.sorted[0]
  result = groups[smallest]


let data = parseData()

benchmark:
  echo data.countCombinations1(150)
  echo data.countCombinations2(150)
