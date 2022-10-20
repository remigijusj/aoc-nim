# Advent of Code 2019 - Day 13

import std/[strutils, sequtils], intcode

const
  symbol = " #*_o"
  vPaddle = 3
  vBall = 4

type Data = seq[int]

# x in 0..43, y in 0..23
type Grid = array[24, array[44, int]]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").map(parseInt)


func buildGrid(data: Data): Grid =
  var ic = data.toIntcode
  while not ic.halted:
    let (x, y, val) = (ic.getOutput, ic.getOutput, ic.getOutput)
    result[y][x] = val


proc display(grid: Grid, score: int) =
  for row in grid:
    echo row.mapIt(symbol[it]).join
  echo "SCORE: " & $score


proc playArkanoid(grid: var Grid, ic: var Intcode): int =
  var paddle: int

  while not ic.halted:
    let (x, y, val) = (ic.getOutput, ic.getOutput, ic.getOutput)
    if x < 0:
      assert x == -1 and y == 0
      result = val
    else:
      grid[y][x] = val
      if val == vPaddle:
        paddle = x
      if val == vBall:
        let joystick = cmp(x, paddle)
        ic.addInput(joystick)
        # grid.display(result)


proc partOne(data: Data): int =
  let grid = data.buildGrid
  for row in grid:
    result.inc(row.count(2))


proc partTwo(data: Data): int =
  var grid = data.buildGrid
  var ic = data.toIntcode
  ic.setVal(2, 0)
  result = playArkanoid(grid, ic)


let data = parseData("inputs/13.txt")
echo partOne(data)
echo partTwo(data)
