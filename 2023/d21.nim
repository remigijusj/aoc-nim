# Advent of Code 2023 - Day 21

import std/[strutils,sets]
import ../utils/common
from math import euclMod

type
  XY = tuple[x, y: int]

  Set = HashSet[XY]

  Data = seq[string]


proc parseData: Data =
  readAll(stdin).strip.splitLines


func findStart(data: Data): XY =
  for y, row in data:
    for x, c in row:
      if c == 'S':
        return (x, y)


iterator neighbors(data: Data, this: XY): XY =
  for (dx, dy) in [(1,0), (-1,0), (0,1), (0,-1)]:
    let next: XY = (this.x + dx, this.y + dy)
    let orig: XY = (euclMod(next.x, data[0].len), euclMod(next.y, data.len))
    if data[orig.y][orig.x] != '#':
      yield next


proc inSteps(data: Data, count: int): int =
  var past, current, future, empty: Set
  future.incl(data.findStart)
  if count mod 2 == 0:
    result = 1
  for gen in 1..count:
    (past, current, future) = (current, future, empty)
    for this in current:
      for next in data.neighbors(this):
        if next notin past:
          future.incl(next)
    if gen mod 2 == count mod 2:
      result += future.card


proc calcThree(data: Data): array[3, int] =
  for n in [0, 1, 2]:
    result[n] = data.inSteps(data.len * n + data.len div 2)


func extrapolateTo(values: array[3, int], n: int): int =
  let a = (values[0] + values[2]) div 2 - values[1]
  let b = 2 * values[1] - (3 * values[0] + values[2]) div 2
  let c = values[0]
  result = (a * n + b) * n + c


let data = parseData()

benchmark:
  echo data.inSteps(64)
  echo data.calcThree.extrapolateTo(26501365 div data.len)
