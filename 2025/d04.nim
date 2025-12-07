# Advent of Code 2025 - Day 4

import std/[strutils,sequtils]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func neighbors(data: Data, x, y: int): int =
  for dy in [-1,0,1]:
    for dx in [-1,0,1]:
      if dx == 0 and dy == 0: continue
      if (x+dx >= 0) and (x+dx < data[0].len) and (y+dy >= 0) and (y+dy < data.len):
        if data[y+dy][x+dx] == '@':
          result.inc


iterator accessible(data: Data): XY =
  for y, line in data:
    for x, c in line:
      if c == '@' and data.neighbors(x, y) < 4:
        yield (x, y)


func countRemovable(data: Data): int =
  var prev = data
  var this = data
  var removed = 0
  while true:
    for pos in prev.accessible:
      this[pos.y][pos.x] = '.'
      removed.inc
      result.inc
    if removed == 0: return
    prev = this
    removed = 0


let data = parseData()

benchmark:
  echo data.accessible.toSeq.len
  echo data.countRemovable
