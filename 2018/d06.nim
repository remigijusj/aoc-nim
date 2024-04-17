# Advent of Code 2018 - Day 6

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Point = tuple[x, y: int]

  Rect = tuple[minx, maxx, miny, maxy: int]

  Data = seq[Point]


func dist(a, b: Point): int = (a.x - b.x).abs + (a.y - b.y).abs


func parsePoint(line: string): Point =
  assert line.scanf("$i, $i", result.x, result.y)


proc parseData: Data =
  readInput().strip.splitLines.map(parsePoint)


func boundaries(data: Data): Rect =
  result.minx = int.high
  result.miny = int.high
  for pt in data:
    if pt.x < result.minx: result.minx = pt.x
    if pt.x > result.maxx: result.maxx = pt.x
    if pt.y < result.miny: result.miny = pt.y
    if pt.y > result.maxy: result.maxy = pt.y


func closest(data: Data, xy: Point): int =
  let distances = data.mapIt(dist(it, xy))
  result = distances.minIndex
  if distances.countIt(it == distances[result]) > 1:
    return -1


func largestFiniteArea(data: Data, rect: Rect): int =
  var area = newSeq[int](data.len)
  var border = newSeq[bool](data.len)

  for x in rect.minx-1 .. rect.maxx+1:
    for y in rect.miny-1 .. rect.maxy+1:
      let idx = data.closest((x, y))
      if idx < 0: continue
      area[idx].inc
      if x < rect.minx or x > rect.maxx or y < rect.miny or y > rect.maxy:
        border[idx] = true

  for idx in 0..<data.len:
    if border[idx]: continue
    if area[idx] > result: result = area[idx]


func totalDistanceArea(data: Data, rect: Rect, limit: int): int =
  for x in rect.minx-1 .. rect.maxx+1:
    for y in rect.miny-1 .. rect.maxy+1:
      let sum = data.mapIt(dist(it, (x, y))).sum
      if sum < limit:
        assert x >= rect.minx and x <= rect.maxx and y >= rect.miny and y <= rect.maxy
        result.inc


let data = parseData()
let rect = data.boundaries

benchmark:
  echo data.largestFiniteArea(rect)
  echo data.totalDistanceArea(rect, 10000)
