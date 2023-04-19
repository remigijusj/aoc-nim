# Advent of Code 2018 - Day 11

import std/[strutils,tables]

type
  Data = int

  XY = array[2, int]

  Grid = Table[XY, int]

  Square = tuple[x, y, size, total: int]


proc parseData: Data =
  readAll(stdin).strip.parseInt


func power(data: Data, cell: XY): int =
  let rack = cell[0] + 10
  result = (rack * cell[1] + data) * rack
  result = result div 100 mod 10 - 5


# Compute power totals for every "prefix" rectangle 1,1 -> x,y
func prefixGrid(data: Data): Grid =
  for x in 0..300: result[[x, 0]] = 0
  for y in 1..300: result[[0, y]] = 0

  for x in 1..300:
    for y in 1..300:
      result[[x, y]] = data.power([x, y]) + result[[x-1, y]] + result[[x, y-1]] - result[[x-1, y-1]]


func largestPowerSquare(grid: Grid, size: int): Square =
  for x in size..300:
    for y in size..300:
      let total = grid[[x, y]] - grid[[x-size, y]] - grid[[x, y-size]] + grid[[x-size, y-size]]
      if total > result.total:
        result = (x-size+1, y-size+1, size, total)


proc largestPowerSquare(grid: Grid, sizes: Slice[int]): Square =
  for size in sizes:
    let square = largestPowerSquare(grid, size)
    if square.total > result.total:
      result = square


func output(square: Square, fmt: string): string =
  result = fmt % [$square[0], $square[1], $square[2]]


let data = parseData()
let grid = data.prefixGrid

echo grid.largestPowerSquare(3).output("$#,$#")
echo grid.largestPowerSquare(1..300).output("$#,$#,$#")
