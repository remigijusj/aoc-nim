# Advent of Code 2024 - Day 15

import std/[strutils,sequtils,tables,algorithm]
import ../utils/common

type
  XY = tuple[x, y: int]

  Grid = seq[string]

  Data = tuple
    grid: Grid
    moves: seq[XY]

const
  moves = {'<': (-1, 0), '^': (0, -1), '>': (1, 0), 'v': (0, 1)}.toTable


func `[]`(grid: Grid, a: XY): char =
  grid[a.y][a.x]

proc `[]=`(grid: var Grid, a: XY, c: char) =
  grid[a.y][a.x] = c

func `+`(a, b: XY): XY =
  (a.x + b.x, a.y + b.y)

proc `+=`(a: var XY, b: XY) =
  a.x += b.x
  a.y += b.y


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.grid = parts[0].split("\n")
  result.moves = parts[1].replace("\n", "").mapIt(moves[it])


func scale2(data: Data): Data =
  result.moves = data.moves
  result.grid = data.grid.mapIt(it.multiReplace([("#", "##"), (".", ".."), ("O", "[]"), ("@", "@.")]))


func findRobot(grid: Grid): XY =
  for y, line in grid:
    for x, c in line:
      if c == '@':
        return (x, y)


func runRobot1(data: Data): Grid =
  result = data.grid
  var robot = result.findRobot
  for move in data.moves:
    var check = robot
    var prev = '@'
    while true:
      check += move
      let this = result[check]
      if this == '#':
        break
      elif this == 'O':
        prev = this
        continue
      elif this == '.':
        result[check] = prev
        result[robot] = '.'
        robot += move
        result[robot] = '@'
        break


func runRobot2(data: Data): Grid =
  result = data.grid
  var robot = result.findRobot
  for i, move in data.moves:
    var stops = false
    var check = @[robot]
    var moved: seq[seq[XY]]

    while check.len > 0:
      var push: seq[XY]
      for item in check:
        let next = item + move
        case result[next]
        of '#':
          stops = true
        of '.':
          continue
        of '[':
          push.add(next)
          if move.y != 0:
            push.add(next + (1, 0))
        of ']':
          push.add(next)
          if move.y != 0:
            push.add(next + (-1, 0))
        else:
          assert false

      if stops: break # short-circuit
      moved.add(check)
      check = push.deduplicate

    # action!
    if stops: continue
    robot += move
    for line in moved.reversed:
      for this in line:
        result[this + move] = result[this]
        result[this] = '.'


func sumGPS(grid: Grid): int =
  for y, line in grid:
    for x, c in line:
      if c in "O[":
        result += 100 * y + x


let data = parseData()

benchmark:
  echo data.runRobot1.sumGPS
  echo data.scale2.runRobot2.sumGPS
