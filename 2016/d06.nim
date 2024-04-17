# Advent of Code 2016 - Day 6

import std/[strutils,sequtils,tables]
import ../utils/common

type
  Data = seq[string]

  Freq = CountTable[char]


proc parseData: Data =
  readInput().strip.splitLines


func frequencies(data: Data): seq[Freq] =
  newSeq(result, data[0].len)
  for line in data:
    for i, c in line:
      result[i].inc(c)


let data = parseData()

benchmark:
  let freq = data.frequencies
  echo freq.mapIt(it.largest.key).join
  echo freq.mapIt(it.smallest.key).join
