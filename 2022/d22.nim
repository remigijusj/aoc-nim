# Advent of Code 2022 - Day 22

import std/[strutils,sequtils,tables]

type
  Op = object
    move: int
    turn: char # L,R

  Grid = seq[string]

  Data = object
    grid: Grid
    path: seq[Op]

  State = tuple[x, y, dir: int]


func parseOp(t: tuple[token: string, isSep: bool]): Op =
  if t.isSep:
    result.turn = t.token[0]
  else:
    result.move = t.token.parseInt


proc parseData: Data =
  let parts = readAll(stdin).strip(leading=false).split("\n\n")
  result.grid = parts[0].splitLines
  for token in parts[1].tokenize({'L','R'}):
    result.path.add token.parseOp


proc move2d(grid: Grid, s: State): State {.noSideEffect.} =
  var (x, y, dir) = s
  if dir == 0:
    x.inc
    if x >= grid[y].len:
      x = 0
      while grid[y][x] == ' ': x.inc

  elif dir == 1:
    y.inc
    if y >= grid.len or x >= grid[y].len or grid[y][x] == ' ':
      y = 0
      while grid[y][x] == ' ': y.inc

  elif dir == 2:
    x.dec
    if x < 0 or grid[y][x] == ' ':
      x = grid[y].high

  elif dir == 3:
    y.dec
    if y < 0 or x >= grid[y].len or grid[y][x] == ' ':
      y = grid.high
      while x >= grid[y].len or grid[y][x] == ' ': y.dec

  result = (x, y, dir)


proc move3d(grid: Grid, s: State): State {.noSideEffect.} =
  var (x, y, dir) = s
  if dir == 0:
    if x == 49 and y in 150..<199:
      result = (y - 100, 149, 3)
    elif x == 99 and y in 100..149:
      result = (149, 149 - y, 2)
    elif x == 99 and y in 50..99:
      result = (y + 50, 49 , 3)
    elif x == 149 and y in 0..49:
      result = (99, 149 - y, 2)
    else:
      result = (x + 1, y, dir)

  elif dir == 1:
    if y == 49 and x in 100..149:
      result = (99, x - 50, 2)
    elif y == 149 and x in 50..99:
      result = (49, x + 100, 2)
    elif y == 199 and x in 0..49:
      result = (x + 100, 0, 1)
    else:
      result = (x, y + 1, dir)

  elif dir == 2:
    if x == 0 and y in 150..199:
      result = (y - 100, 0, 1)
    elif x == 0 and y in 100..149:
      result = (50, 149 - y, 0)
    elif x == 50 and y in 50..99:
      result = (y - 50, 100, 1)
    elif x == 50 and y in 0..49:
      result = (0, 149 - y , 0)
    else:
      result = (x - 1, y, dir)

  elif dir == 3:
    if y == 0 and x in 100..149:
      result = (x - 100, 199, 3)
    elif y == 0 and x in 50..99:
      result = (0, x + 100, 0)
    elif y == 100 and x in 0..49:
      result = (50, x + 50, 0)
    else:
      result = (x, y - 1, dir)


proc tracePath(data: Data, move: proc(grid: Grid, s: State): State): State =
  result = (data.grid[0].find('.'), 0, 0)

  for it in data.path:
    case it.turn
    of 'L':
      result.dir = (result.dir + 3) mod 4
    of 'R':
      result.dir = (result.dir + 1) mod 4
    else:
      for _ in 1..it.move:
        let s1 = move(data.grid, result)
        if data.grid[s1.y][s1.x] == '#':
          break
        result = s1


func password(s: State): int =
  1000 * (s.y + 1) + 4 * (s.x + 1) + s.dir


let data = parseData()

echo data.tracePath(move2d).password
echo data.tracePath(move3d).password
