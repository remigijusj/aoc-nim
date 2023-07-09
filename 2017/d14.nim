# Advent of Code 2017 - Day 14

import std/[strutils,sets,sequtils]
import d10

type
  Data = string

  Grid = seq[string]

  XY = tuple[x, y: int]

  Regions = seq[HashSet[XY]]


proc parseData: Data =
  readAll(stdin).strip


func buildGrid(data: Data): Grid =
  for row in 0..<128:
    let hash = knotHash(data & "-" & $row)
    result.add hash[0..<16].parseHexInt.toBin(64) & hash[16..<32].parseHexInt.toBin(64)


func countSquares(grid: Grid): int =
  for row in 0..<grid.len:
    result += grid[row].count('1')


func find(regions: Regions, xy: XY): int =
  for i, r in regions:
    if xy in r:
      return i
  return -1


func setUnion(grid: Grid): Regions =
  for y, row in grid:
    for x, val in row:
      if val == '0': continue

      let xy = (x, y)
      var lt = result.find (x-1, y)
      var up = result.find (x, y-1)

      if lt < 0 and up < 0:
        result.add [xy].toHashSet
      elif lt < 0:
        result[up].incl(xy)
      elif up < 0:
        result[lt].incl(xy)
      elif lt == up:
        result[lt].incl(xy)
      else:
        result.add result[lt] + result[up] + [xy].toHashSet
        result[lt].clear
        result[up].clear


let data = parseData()
let grid = data.buildGrid

echo grid.countSquares
echo grid.setUnion.countIt(it.card > 0)
