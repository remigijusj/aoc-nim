# Advent of Code 2017 - Day 1

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.mapIt(it.ord - '0'.ord)


func sumMatching(data: Data, delta: int): int =
  for i in 0..<data.len:
    let j = (i + delta) mod data.len
    if data[i] == data[j]:
      result += data[i]


let data = parseData()

benchmark:
  echo data.sumMatching(1)
  echo data.sumMatching(data.len div 2)
