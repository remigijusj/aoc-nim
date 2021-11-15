# Advent of code 2020 - Day 15

import strutils, sequtils, tables

proc readInts(filename: string): seq[int] =
  result = readFile(filename).strip.split(',').mapIt(it.parseInt)


proc play(list: seq[int], limit: int): int =
  var memory = newTable[int, int]()
  for i, val in list: memory[val] = i+1
  for turn in countup(list.len+1, limit-1):
    let delta = memory.getOrDefault(result, turn)
    memory[result] = turn
    result = turn - delta


proc partOne(list: seq[int]): int = list.play(2020)
proc partTwo(list: seq[int]): int = list.play(30000000)


let list = readInts("inputs/15.txt")
echo partOne(list)
echo partTwo(list)
