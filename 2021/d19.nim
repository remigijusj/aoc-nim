# Advent of Code 2021 - Day 19

import std/[sequtils, strscans, strutils, sets, tables]
import memo

const overlap = 12

type
  Vector = array[3, int]

  Rotation = tuple[p: array[3, int], s: array[3, int]]

  Transform = object
    delta: Vector
    rot: Rotation

  Aligns = OrderedTable[int, (int, Transform)]

  Report = seq[Vector]

  Data = seq[Report]


proc parseReport(lines: string): Report =
  var vec: Vector
  for line in lines.split("\n"):
    if line.scanf("$i,$i,$i", vec[0], vec[1], vec[2]):
      result.add(vec)


proc parseData(filename: string): Data =
  for chunk in readFile(filename).strip.split("\n\n"):
    result.add chunk.parseReport


iterator rotations: Rotation =
  for p in [[0,1,2], [1,2,0], [2,0,1]]:
    for s in [[1,1,1], [1,-1,-1], [-1,1,-1], [-1,-1,1]]:
      yield (p, s)

  for p in [[0,2,1], [2,1,0], [1,0,2]]:
    for s in [[-1,-1,-1], [-1,1,1], [1,-1,1], [1,1,-1]]:
      yield (p, s)


proc rotate(v: Vector, rot: Rotation): Vector =
  return [v[rot.p[0]] * rot.s[0], v[rot.p[1]] * rot.s[1], v[rot.p[2]] * rot.s[2]]


proc `-`(u, v: Vector): Vector = [u[0] - v[0], u[1] - v[1], u[2] - v[2]]
proc `+`(u, v: Vector): Vector = [u[0] + v[0], u[1] + v[1], u[2] + v[2]]


proc alignTwo(report1, report2: Report): (bool, Transform) =
  var deltas = CountTable[Vector]()
  for rot in rotations():
    deltas.clear
    for v1 in report1:
      for v2 in report2:
        deltas.inc(v1 - v2.rotate(rot))
    let delta = deltas.largest
    if delta.val >= overlap:
      return (true, Transform(delta: delta.key, rot: rot))


proc alignAll(data: Data): Aligns {.memoized.} =
  result[0] = (-1, Transform())
  while result.len < data.len:
    for i in 1..<data.len:
      block outer:
        if i in result: continue
        for j in result.keys:
          let (ok, t) = alignTwo(data[j], data[i])
          if ok:
            result[i] = (j, t)
            break outer


proc original(v: Vector, table: Aligns, idx: int): Vector =
  result = v
  var (src, t) = table[idx]
  while src >= 0:
    result = result.rotate(t.rot) + t.delta
    (src, t) = table[src]


proc beacons(table: Aligns, data: Data): HashSet[Vector] =
  for idx in table.keys:
    for vector in data[idx]:
      result.incl vector.original(table, idx)


proc scanners(table: Aligns): HashSet[Vector] =
  for idx in table.keys:
    result.incl [0, 0, 0].original(table, idx)


proc maxDistance(vectors: HashSet[Vector]): int =
  for v1 in vectors:
    for v2 in vectors:
      let dist = (v1 - v2).mapIt(it.abs).foldl(a + b)
      if dist > result: result = dist


proc partOne(data: Data): int = data.alignAll.beacons(data).card
proc partTwo(data: Data): int = data.alignAll.scanners.maxDistance


let data = parseData("inputs/19.txt")
echo partOne(data)
echo partTwo(data)
