# Advent of Code 2021 - Day 11

import std/[strutils, sequtils]
import ../utils/common

const Deltas = [(-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)]

type Data = array[100, int]

proc parseData: Data =
  for i, c in readInput().replace("\n", ""):
    result[i] = c.ord - '0'.ord


iterator neighbours(pos: int): int =
  let (x, y) = (pos mod 10, pos div 10)
  for (dx, dy) in Deltas:
    let (nx, ny) = (x + dx, y + dy)
    if nx in 0..9 and ny in 0..9:
      yield ny * 10 + nx


proc flash(data: var Data, pos: int) =
  data[pos] = 0
  for adj in neighbours(pos):
    if data[adj] > 0: data[adj].inc
    if data[adj] > 9: data.flash(adj)


proc simulateStep(data: var Data) =
  data.applyIt(it + 1)
  for pos in 0..<data.len:
    if data[pos] > 9: data.flash(pos)


proc countFlashes(data: Data, steps: int): int =
  var grid = data
  for step in countup(1, steps):
    grid.simulateStep
    result += grid.count(0)


proc findSimultaneousFlash(data: Data): int =
  var grid = data
  for step in countup(1, int.high):
    grid.simulateStep
    if grid.count(0) == data.len:
      return step


let data = parseData()

benchmark:
  echo data.countFlashes(100)
  echo data.findSimultaneousFlash
