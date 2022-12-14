# Advent of Code 2022 - Day 14

import std/[strutils,strscans,sequtils,sets]

type
  XY = tuple[x, y: int]
  Path = seq[XY]
  Data = seq[Path]
  Grid = HashSet[XY]

const origin: XY = (500, 0)


func parseXY(s: string): XY = discard s.scanf("$i,$i", result.x, result.y)

func parseLine(line: string): Path = line.split(" -> ").map(parseXY)

proc parseData: Data = readAll(stdin).strip.splitLines.map(parseLine)


func buildGrid(data: Data): Grid =
  var this: XY
  for trace in data:
    this = trace[0]
    for next in trace[1..^1]:
      if next.x == this.x:
        for y in min(this.y, next.y)..max(this.y, next.y):
          result.incl (this.x, y)
      elif next.y == this.y:
        for x in min(this.x, next.x)..max(this.x, next.x):
          result.incl (x, this.y)
      this = next


func bottom(grid: Grid): int =
  for cell in grid:
    if cell.y > result: result = cell.y


func fillSand(grid: Grid, floor: bool): int =
  var heap = grid
  let limit = grid.bottom + 1

  var sand: XY
  while true:
    sand = origin
    while sand.y < limit:
      if (sand.x, sand.y+1) notin heap:
        sand.y.inc
      elif (sand.x-1, sand.y+1) notin heap:
        sand.x.dec
        sand.y.inc
      elif (sand.x+1, sand.y+1) notin heap:
        sand.x.inc
        sand.y.inc
      else:
        heap.incl sand
        break

    if sand.y == limit:
      if floor:
        heap.incl sand
      else:
        break
    if sand.y == origin.y:
      break

  result = heap.card - grid.card


let data = parseData()
let grid = data.buildGrid

let part1 = grid.fillSand(false)
let part2 = grid.fillSand(true)

echo part1
echo part2
