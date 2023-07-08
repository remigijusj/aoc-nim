# Advent of Code 2017 - Day 13

import std/[strscans,strutils,sequtils,tables]

type Data = Table[int, int]


func parseScanner(line: string): (int, int) =
  assert line.scanf("$i: $i", result[0], result[1])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseScanner).toTable


func maxDepth(data: Data): int =
  data.keys.toSeq.max


func collision(size: int, step: int): bool =
  let period = 2 * size - 2
  return step mod period == 0


func totalSeverity(data: Data): int =
  for depth in 0..data.maxDepth:
    if depth in data and collision(data[depth], depth):
      result += depth * data[depth]


func smallestDelay(data: Data): int =
  let maxDepth = data.maxDepth
  for delay in 0..<int.high:
    block thisDelay:
      for depth in 0..maxDepth:
        if depth in data and collision(data[depth], delay + depth):
          break thisDelay
      return delay


let data = parseData()

echo data.totalSeverity
echo data.smallestDelay
