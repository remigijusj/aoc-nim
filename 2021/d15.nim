# Advent of Code 2021 - Day 15

import std/[sequtils, strutils]
import astar # https://github.com/Nycto/AStarNim
import ../utils/common

type
  Grid = seq[seq[int]]

  Node = tuple[x, y: int]


proc parseData: Grid =
  for line in readInput().strip.splitLines:
    result.add line.mapIt(it.ord - '0'.ord)


iterator neighbors(grid: Grid, n: Node): Node =
  let line = grid[n.y]
  if n.x > line.low:  yield (n.x - 1, n.y)
  if n.x < line.high: yield (n.x + 1, n.y)
  if n.y > grid.low:  yield (n.x, n.y - 1)
  if n.y < grid.high: yield (n.x, n.y + 1)


proc heuristic(grid: Grid, a, b: Node): int = max(abs(a.x - b.x), abs(a.y - b.y))

proc cost(grid: Grid, a, b: Node): int = grid[b.y][b.x]


proc lowestRiskDiagonal(grid: Grid): int =
  let start = (0, 0)
  let finish = (grid[^1].high, grid.high)
  for node in path[Grid, Node, int](grid, start, finish):
    if node != start:
      result += grid.cost(start, node)


proc inflate(grid: Grid, times: int): Grid =
  result = grid.mapIt(it.cycle(times))
  result = result.cycle(times)

  for y, row in mpairs(result):
    for x, val in mpairs(row):
      let (cx, cy) = (x div grid.len, y div grid.len)
      val = (val + cx + cy - 1) mod 9 + 1


let data = parseData()

benchmark:
  echo data.lowestRiskDiagonal
  echo data.inflate(5).lowestRiskDiagonal
