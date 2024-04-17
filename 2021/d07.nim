# Advent of Code 2021 - Day 7

import std/[strutils, sequtils, algorithm]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(",").mapIt(it.parseInt)


proc fuel1(x, y: int): int = (x - y).abs
proc fuel2(x, y: int): int = (x - y).abs * ((x - y).abs + 1) div 2


proc median(data: Data): int = data.sorted[data.len div 2]
proc mean(data: Data): int = data.sum div data.len


proc minimum(data: Data, fuel: proc(x, y: int): int, guess: proc(data: Data): int): int =
  let pos = data.guess
  result = data.mapIt(fuel(it, pos)).sum
  for x in [pos-1, pos+1]:
    let variant = data.mapIt(fuel(it, x)).sum
    if variant < result: result = variant


let data = parseData()

benchmark:
  echo data.minimum(fuel1, median)
  echo data.minimum(fuel2, mean)
