# Advent of Code 2022 - Day 1

import std/[strutils,sequtils,algorithm]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  let chunks = readInput().strip.split("\n\n")
  for chunk in chunks:
    result.add chunk.split("\n").map(parseInt).sum


var data = parseData()
data.sort(SortOrder.Descending)

benchmark:
  echo data[0]
  echo data[0..2].sum
