# Advent of Code 2018 - Day 10

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  XY = array[2, int]

  Point = tuple[position, velocity: XY]

  Data = seq[Point]


func `+`(a, b: XY): XY = [a[0]+b[0], a[1]+b[1]]
func `*`(a: XY, c: int): XY = [a[0]*c, a[1]*c]

func parsePoint(line: string): Point =
  assert line.scanf("position=<$s$i,$s$i> velocity=<$s$i,$s$i>",
    result.position[0], result.position[1], result.velocity[0], result.velocity[1])


proc parseData: Data =
  readInput().strip.splitLines.map(parsePoint)


proc step(points: var seq[XY], data: Data, count = 1) =
  for i, p in data:
    points[i] = points[i] + (p.velocity * count)


func boundary(points: seq[XY]): (XY, XY) =
  var min: XY = [int.high, int.high]
  var max: XY = [-int.high, -int.high]
  for p in points:
    if p[0] < min[0]: min[0] = p[0]
    if p[0] > max[0]: max[0] = p[0]
    if p[1] < min[1]: min[1] = p[1]
    if p[1] > max[1]: max[1] = p[1]
  result = (min, max)


func area(points: seq[XY]): int =
  let (min, max) = points.boundary
  result = (max[0] - min[0]) * (max[1] - min[1])


func `$`(points: seq[XY]): string =
  let (min, max) = points.boundary
  for y in min[1] .. max[1]:
    for x in min[0] .. max[0]:
      if points.anyIt(it == [x, y]):
        result.add('#')
      else:
        result.add(' ')
    result.add('\n')


proc simulatePoints(data: Data): (string, int) =
  var points = data.mapIt(it.position)
  var prev = int.high
  for step in 0..int.high:
    points.step(data)
    let this = points.area
    if this > prev:
      points.step(data, -1)
      return ($points, step)
    else:
      prev = this


let data = parseData()

benchmark:
  let (message, seconds) = data.simulatePoints

  echo message
  echo seconds
