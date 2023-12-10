# Advent of Code 2023 - Day 10

import std/[strutils]
import ../utils/common

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Loop = tuple
    len, area2: int # double area


const
  moves: array[4, XY] = [(1, 0), (0, -1), (-1, 0), (0, 1)]


proc parseData: Data =
  readAll(stdin).strip.splitLines


func start(data: Data): XY =
  for y, line in data:
    for x, c in line:
      if c == 'S':
        result = (x, y)


proc turn(c: char, dir: var int) =
  let ix = "J7FL".find(c)
  if ix < 0:
    return
  if dir == ix:
    dir = (dir + 1) mod 4
  else:
    dir = (dir + 3) mod 4


func findLoop(data: Data, pos: XY, dir: int): Loop =
  var pos = pos
  var dir = dir
  while true:
    let move = moves[dir]
    pos.x += move.x
    pos.y += move.y
    let mult = moves[(dir + 1) mod 4]
    result.area2 += pos.x * mult.x + pos.y * mult.y # from shoelace formula
    result.len.inc
    let c = data[pos.y][pos.x]
    if c == 'S':
      return
    c.turn(dir)


let data = parseData()
let loop = data.findLoop(data.start, 0)

benchmark:
  echo loop.len div 2
  echo (loop.area2.abs div 2) - (loop.len div 2) + 1 # Pick's theorem
