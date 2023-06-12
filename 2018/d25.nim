# Advent of Code 2018 - Day 25

import std/[strutils,sequtils]

type
  Point = array[4, int]

  Data = seq[Point]


func dist(a, b: Point): int = zip(a, b).mapIt(abs(it[0] - it[1])).foldl(a + b)


func parsePoint(line: string): Point =
  let ns = line.split(",").map(parseInt)
  result = [ns[0], ns[1], ns[2], ns[3]]


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parsePoint)


func countConstellations(data: Data): int =
  var parent = toSeq(0..<data.len)

  proc top(x: int): int =
    if parent[x] != x:
      parent[x] = top(parent[x])
    return parent[x]

  for ix, x in data:
    for iy, y in data:
      if iy < ix and dist(x, y) <= 3:
        let tx = top(ix)
        let ty = top(iy)
        if tx != ty:
          parent[ty] = tx

  var tops = parent.mapIt(top(it))
  result = tops.deduplicate.len


let data = parseData()

echo data.countConstellations
