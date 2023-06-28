# Advent of Code 2017 - Day 2

import std/[strutils,sequtils,math]

type Data = seq[seq[int]]


func parseLine(line: string): seq[int] =
  line.splitWhitespace.map(parseInt)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseLine)


func evenDivide(row: seq[int]): int =
  for i, n in row:
    for j, m in row:
      if i == j: continue
      if n mod m == 0: return n div m


let data = parseData()

echo data.mapIt(it.max - it.min).sum
echo data.map(evenDivide).sum
