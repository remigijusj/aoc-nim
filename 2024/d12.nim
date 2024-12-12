# Advent of Code 2024 - Day 12

import std/[strutils,sequtils,sets]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[string]

  Region = tuple
    name: char
    cells: HashSet[XY]


proc parseData: Data =
  readInput().strip.splitLines


proc mergeRegions(a, b: var Region, index: var seq[seq[int]], it: int) =
  a.cells = a.cells + b.cells
  for (x, y) in b.cells:
    index[y][x] = it
  b.cells.clear


func findRegions(data: Data): seq[Region] =
  var index = newSeqWith(data.len, newSeqWith(data[0].len, -1))
  for y, line in data:
    for x, name in line:
      let up = if y > 0: index[y-1][x] else: -1
      let lt = if x > 0: index[y][x-1] else: -1

      if up >= 0 and lt >= 0 and up != lt and name == result[up].name and name == result[lt].name:
        mergeRegions(result[up], result[lt], index, up)

      let it =
        if up >= 0 and name == result[up].name:
          up
        elif lt >= 0 and name == result[lt].name:
          lt
        else:
          result.add (name, initHashSet[XY]())
          result.len-1

      result[it].cells.incl (x, y)
      index[y][x] = it


func area(reg: Region): int =
  reg.cells.card


func perimeter(reg: Region): int =
  for (x, y) in reg.cells:
    result += 4
    if (x-1, y) in reg.cells:
      result -= 2
    if (x, y-1) in reg.cells:
      result -= 2


func hasCorner(reg: Region, o, d: XY): bool {.inline.} =
  ((o.x+d.x, o.y) notin reg.cells and (o.x, o.y+d.y) notin reg.cells) or
  ((o.x+d.x, o.y)    in reg.cells and (o.x, o.y+d.y)    in reg.cells and (o.x+d.x, o.y+d.y) notin reg.cells)


func corners(reg: Region): int =
  for it in reg.cells:
    if reg.hasCorner(it, (-1, -1)): result.inc
    if reg.hasCorner(it, (-1, +1)): result.inc
    if reg.hasCorner(it, (+1, +1)): result.inc
    if reg.hasCorner(it, (+1, -1)): result.inc


let data = parseData()

benchmark:
  let regions = data.findRegions
  echo regions.mapIt(it.area * it.perimeter).sum
  echo regions.mapIt(it.area * it.corners).sum
