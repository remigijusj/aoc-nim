# Advent of Code 2023 - Day 6

import std/[strutils,sequtils,math]
import ../utils/common

type
  Race = tuple
    time, dist: int

  Data = seq[Race]


proc parseData: Data =
  var lines = readInput().strip.splitLines
  let time = lines[0][5..^1].strip.splitWhitespace.map(parseInt)
  let dist = lines[1][9..^1].strip.splitWhitespace.map(parseInt)
  result = zip(time, dist)


func countWins(r: Race): int =
  let det = (r.time * r.time - 4 * r.dist).float.sqrt
  if r.time mod 2 == 0: # -> closest odd/even
    result = (det / 2).ceil.int * 2 - 1
  else:
    result = ((det - 1) / 2).ceil.int * 2


func combine(data: Data): Race =
  let time = data.mapIt($it.time).join.parseInt
  let dist = data.mapIt($it.dist).join.parseInt
  result = (time, dist)


let data = parseData()

benchmark:
  echo data.map(countWins).prod
  echo data.combine.countWins
