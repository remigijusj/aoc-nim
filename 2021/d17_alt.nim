# Advent of Code 2021 - Day 17

import std/[strscans, sequtils]

type
  Vector = tuple[x, y: int]

  Data = object
    xmin, xmax: int
    ymin, ymax: int


proc parseData(filename: string): Data =
  let data = readfile(filename)
  discard data.scanf("target area: x=$i..$i, y=$i..$i", result.xmin, result.xmax, result.ymin, result.ymax)


proc hit(data: Data, shot: Vector): bool =
  var x, y: int = 0
  var (dx, dy) = shot
  while y >= data.ymin and x <= data.xmax:
    x += dx
    y += dy
    if dx > 0: dx.dec
    dy.dec
    if x >= data.xmin and x <= data.xmax and y >= data.ymin and y <= data.ymax:
      return true


iterator shots(data: Data): Vector =
  for x in countup(1, data.xmax):
    for y in countup(data.ymin, data.ymin.abs):
      yield (x, y)


proc triangular(n: int): int = n * (n+1) div 2

proc partOne(data: Data): int = triangular(data.ymin.abs - 1)
proc partTwo(data: Data): int = data.shots.countIt(data.hit(it))

let data = parseData("inputs/17.txt")
echo partOne(data)
echo partTwo(data)
