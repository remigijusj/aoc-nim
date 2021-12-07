# Advent of Code 2021 - Day 7

import std/[strutils, sequtils, algorithm]

type Data = seq[int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").mapIt(it.parseInt)


proc fuel1(x, y: int): int = (x - y).abs
proc fuel2(x, y: int): int = (x - y).abs * ((x - y).abs + 1) div 2


proc median(data: Data): int = data.sorted[data.len div 2]
proc mean(data: Data): int = data.foldl(a + b) div data.len


proc minimum(data: Data, fuel: proc(x, y: int): int, guess: proc(data: Data): int): int =
  let pos = data.guess
  result = data.mapIt(fuel(it, pos)).foldl(a + b)
  for x in [pos-1, pos+1]:
    let variant = data.mapIt(fuel(it, x)).foldl(a + b)
    if variant < result: result = variant


proc partOne(data: Data): int = data.minimum(fuel1, median)
proc partTwo(data: Data): int = data.minimum(fuel2, mean)


let data = parseData("inputs/07.txt")
echo partOne(data)
echo partTwo(data)
