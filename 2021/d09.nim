# Advent of Code 2021 - Day 9

import std/[sequtils, strutils, algorithm]
import ../utils/common

type
  Data = seq[seq[int]]

  Point = tuple[x, y: int]


proc `[]`(data: Data, point: Point): int = data[point.x][point.y]


proc parseData: Data =
  for line in readInput().strip.splitLines:
    result.add line.mapIt(it.ord - '0'.ord)


proc neighbours(data: Data, point: Point): seq[Point] =
  let (x, y) = (point.x, point.y)
  if x > 0: result.add (x-1, y)
  if y > 0: result.add (x, y-1)
  if y < data[x].len-1: result.add (x, y+1)
  if x < data.len-1: result.add (x+1, y)


proc lowPoints(data: Data): seq[Point] =
  for ri, row in data:
    for ci, value in row:
      let point = (ri, ci)
      if value < data.neighbours(point).mapIt(data[it]).min:
        result.add point


proc basin(start: Point, data: Data): seq[Point] =
  result = @[start]
  var marker = 0

  while marker < result.len:
    for point in result[marker..^1]:
      for pt in data.neighbours(point):
        if pt notin result and data[pt] < 9:
          result.add pt

    marker.inc


let data = parseData()

benchmark:
  echo data.lowPoints.mapIt(data[it] + 1).sum
  echo data.lowPoints.mapIt(it.basin(data).len).sorted(Descending)[0..2].prod
