# Advent of Code 2022 - Day 15

import std/[strutils,strscans,sequtils,algorithm]
import ../utils/common

const
  row = 2_000_000
  max = 4_000_000

type
  XY = tuple[x, y: int]
  Interval = tuple[a, b: int]
  Reading = tuple[sensor, beacon: XY]
  Data = seq[Reading]


func dist(a, b: XY): int = (a.x - b.x).abs + (a.y - b.y).abs

func radius(it: Reading): int = dist(it.sensor, it.beacon)


func parseReading(line: string): Reading =
  discard line.scanf("Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i",
    result.sensor.x, result.sensor.y, result.beacon.x, result.beacon.y)


proc parseData: Data =
  readInput().strip.splitLines.map(parseReading)


proc findIntervals(data: Data, row: int): seq[Interval] =
  for it in data:
    let r = it.radius
    let h = abs(it.sensor.y - row)
    if h <= r:
      result.add (it.sensor.x - r + h, it.sensor.x + r - h)

  result.sort do (x, y: Interval) -> int:
    cmp(x.a, y.a)


func coveredLength(ints: seq[Interval]): int =
  var cover = ints[0]
  for iv in ints[1..^1]:
    if iv.a in cover.a..cover.b:
      if iv.b > cover.b:
        cover.b = iv.b
    else:
      result.inc(cover.b - cover.a + 1)
      cover = iv

  result.inc(cover.b - cover.a + 1)


func countBeacons(data: Data, row: int): int =
  var list: seq[int]
  for it in data:
    if it.beacon.y == row:
      list.add it.beacon.x

  result = list.deduplicate.len


func findUncoveredPoint(data: Data, lim: int): XY =
  let pos1 = data.mapIt(it.sensor.x + it.sensor.y + it.radius + 1)
  let pos2 = data.mapIt(it.sensor.x + it.sensor.y - it.radius - 1)
  let neg1 = data.mapIt(it.sensor.x - it.sensor.y + it.radius + 1)
  let neg2 = data.mapIt(it.sensor.x - it.sensor.y - it.radius - 1)

  for a in concat(pos1, pos2):
    for b in concat(neg1, neg2):
      let x = (a + b) div 2
      let y = (a - b) div 2
      if x in 0..lim and y in 0..lim:
        let point = (x, y)
        if data.allIt dist(point, it.sensor) > it.radius:
          return point


func tuningFrequency(point: XY, lim: int): int = point.x * lim + point.y


let data = parseData()

benchmark:
  echo data.findIntervals(row).coveredLength - data.countBeacons(row)
  echo data.findUncoveredPoint(max).tuningFrequency(max)
