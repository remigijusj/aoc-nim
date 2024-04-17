# Advent of Code 2019 - Day 15

import std/[strutils,sequtils,tables,deques]
import intcode
import ../utils/common

type
  Move = enum
    here  = 0
    north = 1
    south = 2
    west  = 3
    east  = 4

  Resp = enum
    stay  = 0
    move  = 1
    halt  = 2

  Cell = tuple[x, y: int]

  Grid = Table[Cell, int]

  Data = seq[int]

const moveback = [here, south, north, east, west]


var ic: Intcode
var grid: Grid
var oxy: Cell


iterator neighbors(cell: Cell): (Cell, Move) =
  let (x, y) = cell
  yield ((x, y-1), north)
  yield ((x, y+1), south)
  yield ((x-1, y), west)
  yield ((x+1, y), east)


proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


# DFS, recursive, full
proc exploreMaze(this: Cell, back: Move) =
  if this notin grid:
    grid[this] = 0 # start cell only

  for cell, op in this.neighbors:
    if cell in grid: continue # visited

    let resp = Resp(ic.getOutput(op.int))
    case resp
      of stay:
        grid[cell] = -1 # wall
      of move, halt:
        if resp == halt:
          oxy = cell
        grid[cell] = grid[this] + 1
        exploreMaze(cell, moveback[op.int])

  if back != here:
    assert Resp(ic.getOutput(back.int)) == move # backtrack


proc floodFill(start: Cell) =
  var front = [start].toDeque
  while front.len > 0:
    let this = front.popFirst
    for cell, _ in this.neighbors:
      if grid[cell] == 0 and cell != start:
        grid[cell] = grid[this] + 1
        front.addLast(cell)


proc minMoves(data: Data): int =
  ic = data.toIntcode
  exploreMaze((0, 0), here)
  result = grid[oxy]


proc fillOxygen(data: Data): int =
  for cell, val in grid:
    if val >= 0: grid[cell] = 0
  floodFill(oxy)
  for cel, val in grid:
    if val > result: result = val


let data = parseData()

benchmark:
  echo data.minMoves
  echo data.fillOxygen
