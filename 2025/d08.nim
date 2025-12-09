# Advent of Code 2025 - Day 8

import std/[strscans,strutils,sequtils,algorithm,intsets]
import ../utils/common
from math import `^`

type
  Point = array[3, int]

  Data = seq[Point]

  Distances = seq[(int,int,int)] # (dist, i, j)


func parsePoint(line: string): Point =
  assert line.scanf("$i,$i,$i", result[0], result[1], result[2])


proc parseData: Data =
  readInput().strip.splitLines.map(parsePoint)


func distancesSorted(data: Data): Distances =
  for i, a in data:
    for j, b in data:
      if j <= i: continue
      let d2 = (a[0]-b[0])^2 + (a[1]-b[1])^2 + (a[2]-b[2])^2
      result.add (d2, i, j)
  result.sort


proc add(circuits: var seq[IntSet], i, j: int) =
  let ic = circuits.findIt(i in it)
  let jc = circuits.findIt(j in it)
  if ic >= 0 and jc >= 0:
    if ic != jc: # merge
      circuits[ic].incl(circuits[jc])
      circuits.del(jc)
  elif ic >= 0:
    circuits[ic].incl(j)
  elif jc >= 0:
    circuits[jc].incl(i)
  else:
    let c = [i, j].toIntSet
    circuits.add(c)


func connectClosest(dist: Distances, limit: int, top: int): int =
  var circuits: seq[IntSet]
  for (_, i, j) in dist[0..<limit]:
    circuits.add(i, j)

  var sizes = circuits.mapIt(it.card)
  sizes.sort(Descending)
  result = sizes[0..<top].prod


func connectAll(dist: Distances, data: Data): int =
  var circuits: seq[IntSet]
  for (_, i, j) in dist:
    circuits.add(i, j)

    if circuits.len == 1 and circuits[0].card == data.len:
      return data[i][0] * data[j][0]


let data = parseData()

benchmark:
  let dist = data.distancesSorted
  echo dist.connectClosest(1000, 3)
  echo dist.connectAll(data)
