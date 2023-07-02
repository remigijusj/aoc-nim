# Advent of Code 2017 - Day 3

import std/[strutils,tables,math]

type
  Point = tuple[x, y: int]

  Values = Table[Point, int]

  Dir = enum
    right, up, left, down

  Data = int


func norm(p: Point): int = p.x.abs + p.y.abs

func level(p: Point): int = max(p.x.abs, p.y.abs)


proc parseData: Data =
  readAll(stdin).strip.parseInt


func next(pnt: Point): Dir =
  let l = pnt.level
  if pnt.y == -l:
    return right
  elif pnt.x == -l:
    return down
  elif pnt.y == l:
    return left
  else:
    return up


iterator spiral: Point =
  var pnt: Point
  while true:
    yield pnt
    case pnt.next:
      of right: pnt.x.inc
      of up:    pnt.y.inc
      of left:  pnt.x.dec
      of down:  pnt.y.dec


func normOfPoint(data: Data): int =
  var num = 0
  for pnt in spiral():
    num.inc
    if num == data:
      return pnt.norm


func sumNeighbors(pnt: Point, values: Values): int =
  for dx in -1..1:
    for dy in -1..1:
      if dx == 0 and dy == 0: continue
      result += values.getOrDefault((pnt.x + dx, pnt.y + dy))
  if result == 0:
    result = 1


func fillSummed(data: Data): int =
  var values: Values
  for pnt in spiral():
    let val = pnt.sumNeighbors(values)
    values[pnt] = val
    if val > data:
      return val


let data = parseData()

echo data.normOfPoint
echo data.fillSummed
