# Advent of Code 2024 - Day 10

import std/[strutils,sequtils,deques]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[seq[int]]


func parseLine(line: string): seq[int] =
  line.mapIt(it.ord - '0'.ord)

proc parseData: Data =
  readInput().strip.splitLines.map(parseLine)


iterator trailheads(data: Data): XY =
  for y, line in data:
    for x, h in line:
      if h == 0:
        yield (x, y)


func `[]`(data: Data, pos: XY): int {.inline.} =
  data[pos.y][pos.x]


iterator neighbors(data: Data, pos: XY): XY =
  if pos.y > 0:
    yield (pos.x, pos.y-1)
  if pos.x < data[0].len-1:
    yield (pos.x+1, pos.y)
  if pos.y < data.len-1:
    yield (pos.x, pos.y+1)
  if pos.x > 0:
    yield (pos.x-1, pos.y)


func trailheadScores(data: Data, rating: bool): int =
  for head in data.trailheads:
    var queue = [head].toDeque
    var ends: seq[XY]
    while queue.len > 0:
      let this = queue.popFirst
      if data[this] == 9:
        if rating or this notin ends:
          ends.add(this)
      else:
        for next in data.neighbors(this):
          if data[next] == data[this] + 1:
            queue.addLast(next)
    result += ends.len


let data = parseData()

benchmark:
  echo data.trailheadScores(rating=false)
  echo data.trailheadScores(rating=true)
