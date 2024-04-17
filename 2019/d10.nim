# Advent of Code 2019 - Day 10

import std/[strutils, sequtils, complex, tables, algorithm]
from math import PI
import ../utils/common

type
  Point = Complex32

  Data = seq[Point]


proc nearer(a, o, b: Point): bool = (a - o).abs < (b - o).abs


proc parseData: Data =
  let lines = readInput().strip.split("\n")
  for y, line in lines:
    for x, ch in line:
      if ch == '#':
        result.add complex(x.float32, y.float32)


proc partOne(data: Data): tuple[p: Point, cnt: int] =
  for point in data:
    var phases = newSeqOfCap[float32](data.len)
    for other in data:
      if other == point: continue
      phases.add (other - point).phase

    let visible = phases.deduplicate.len
    if visible > result.cnt:
      result.p = point
      result.cnt = visible


proc partTwo(data: Data, origin: Point): int =
  var hold: Table[int, Point]
  for point in data:
    if point == origin: continue

    var angle = (point - origin).phase + PI * 0.5
    if angle < -0.00001: angle += PI * 2.0
    let key = int(angle * 1000000)

    if key notin hold or nearer(point, origin, hold[key]):
      hold[key] = point

  let angles = toSeq(hold.keys).sorted
  let point = hold[angles[199]]
  result = point.re.int * 100 + point.im.int


let data = parseData()

benchmark:
  let (origin, count) = data.partOne
  echo count
  echo data.partTwo(origin)
