# Advent of Code 2021 - Day 5

import std/[strscans, strutils, sequtils, tables]
import ../utils/common

type
  Point = tuple[x, y: int]

  Line = tuple[a, b: Point]

  Data = seq[Line]

proc parseLine(line: string): Line =
  discard line.scanf("$i,$i -> $i,$i", result.a.x, result.a.y, result.b.x, result.b.y)


proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.parseLine)


iterator points(line: Line): Point =
  let dx = cmp(line.b.x, line.a.x)
  let dy = cmp(line.b.y, line.a.y)
  var point = line.a
  while true:
    yield point
    if point == line.b: break
    point.x += dx
    point.y += dy


proc countOverlaps(data: Data, axial: bool = false): int =
  var tally: CountTable[Point]
  for line in data:
    if axial and not (line.a.x == line.b.x or line.a.y == line.b.y):
      continue
    for point in line.points:
      tally.inc(point)
      if tally[point] == 2: result.inc


let data = parseData()

benchmark:
  echo data.countOverlaps(axial = true)
  echo data.countOverlaps
