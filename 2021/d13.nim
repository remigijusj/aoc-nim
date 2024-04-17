# Advent of Code 2021 - Day 13

import std/[sequtils, strutils, strscans]
import ../utils/common

type
  Point = array[2, int]
  Fold = tuple[axis, value: int]

  Data = object
    points: seq[Point]
    folds: seq[Fold]


proc parsePoint(line: string): Point =
  let (ok, x, y) = line.scanTuple("$i,$i")
  if ok: result = [x, y]


proc parseFold(line: string): Fold =
  let (ok, xy, value) = line.scanTuple("fold along $w=$i")
  let axis = if xy == "y": 1 else: 0
  if ok: result = (axis, value)


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.points = parts[0].split("\n").mapIt(it.parsePoint)
  result.folds = parts[1].split("\n").mapIt(it.parseFold)


proc applyFold(points: var seq[Point], fold: Fold) =
  for point in mitems(points):
    if point[fold.axis] > fold.value:
      point[fold.axis] = 2 * fold.value - point[fold.axis]

  points.keepItIf(it[fold.axis] < fold.value)
  points = points.deduplicate


proc applyFolds(data: Data, folds: seq[Fold] = data.folds): seq[Point] =
  result = data.points
  for fold in folds:
    result.applyFold(fold)


proc `$`(points: seq[Point]): string =
  let lenx = points.mapIt(it[0]).max + 2
  let leny = points.mapIt(it[1]).max + 1
  var lines = newSeqWith(leny, newSeqWith(lenx, ' '))
  for p in points:
    lines[p[1]][p[0]] = '#'

  result = lines.mapIt(it.join).join("\n")


let data = parseData()

benchmark:
  echo data.applyFolds(folds = data.folds[0..0]).len
  echo ($data.applyFolds).decodeBF6
