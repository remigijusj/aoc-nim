# Advent of Code 2025 - Day 9

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  XY = tuple[x, y: int]
  Rect = (XY, XY)
  Data = seq[XY]


func parseXY(line: string): XY =
  assert line.scanf("$i,$i", result.x, result.y)


proc parseData: Data =
  readInput().strip.splitLines.map(parseXY)


func rect(a, b: XY): Rect =
  result = (a, b)
  if result[0].x > result[1].x: swap(result[0].x, result[1].x)
  if result[0].y > result[1].y: swap(result[0].y, result[1].y)


func area(rect: Rect): int {.inline.} =
  (rect[1].x - rect[0].x + 1) * (rect[1].y - rect[0].y + 1)


proc largestArea(data: Data, ok: proc(data: Data, rect: Rect): bool = nil): int =
  for j in 0..<data.len:
    for i in 0..<j:
      let this = rect(data[i], data[j])
      let area = this.area
      if area > result and (ok == nil or data.ok(this)):
        result = area


# strictly inside
func contains(rect: Rect, p: XY): bool =
  result = (rect[0].x < p.x and p.x < rect[1].x and rect[0].y < p.y and p.y < rect[1].y)


func cross(rect: Rect, p1, p2: XY): bool =
  if p1.x == p2.x:
    let (y1, y2) = minmax([p1.y, p2.y])
    result = rect[0].x < p1.x and p1.x < rect[1].x and y1 <= rect[0].y and rect[1].y <= y2

  elif p1.y == p2.y:
    let (x1, x2) = minmax([p1.x, p2.x])
    result = rect[0].y < p1.y and p1.y < rect[1].y and x1 <= rect[0].x and rect[1].x <= x2


# should check if some inner point is inside
func fits(data: Data; rect: Rect): bool =
  result = true
  for i in 0..<data.len:
    let p1 = data[i]
    let p2 = data[(i+1) mod data.len]
    if rect.contains(p1) or rect.cross(p1, p2):
      return false


let data = parseData()

benchmark:
  echo data.largestArea
  echo data.largestArea(fits)
