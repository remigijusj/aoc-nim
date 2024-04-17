# Advent of Code 2018 - Day 3

import std/[strscans,strutils,sequtils,tables,sugar]
import ../utils/common

type
  Cell = tuple[x, y: int]

  Claim = object
    id: int
    x, y: int
    w, h: int

  Data = seq[Claim]

  Grid = CountTable[Cell]


func parseClaim(line: string): Claim =
  assert line.scanf("#$i @ $i,$i: $ix$i", result.id, result.x, result.y, result.w, result.h)


proc parseData: Data =
  readInput().strip.splitLines.map(parseClaim)


iterator cells(claim: Claim): Cell =
  for x in claim.x ..< claim.x + claim.w:
    for y in claim.y ..< claim.y + claim.h:
      yield (x, y)


func buildGrid(data: Data): Grid =
  for claim in data:
    for cell in claim.cells:
      result.inc(cell)


func overlapArea(grid: Grid): int =
  for cnt in grid.values:
    if cnt > 1:
      result.inc


func nonOverlappingClaim(data: Data, grid: Grid): int =
  for claim in data:
    var overlap = false
    for cell in claim.cells:
      if grid.getOrDefault(cell) > 1:
        overlap = true
    if not overlap:
      return claim.id


let data = parseData()
let grid = data.buildGrid

benchmark:
  echo grid.overlapArea
  echo data.nonOverlappingClaim(grid)
