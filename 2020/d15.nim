# Advent of code 2020 - Day 15

import std/[strutils, sequtils, tables]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  result = readInput().strip.split(',').map(parseInt)


proc play(list: Data, limit: int): int =
  var memory = newTable[int, int]()
  for i, val in list: memory[val] = i+1
  for turn in countup(list.len+1, limit-1):
    let delta = memory.getOrDefault(result, turn)
    memory[result] = turn
    result = turn - delta


let data = parseData()

benchmark:
  echo data.play(2020)
  echo data.play(30_000_000)
