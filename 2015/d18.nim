# Advent of Code 2015 - Day 18

import std/[strutils]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func neighbors(data: Data, x, y: int): int {.inline.} =
  for dy in -1..1:
    for dx in -1..1:
      if dx == 0 and dy == 0:
        continue
      let (nx, ny) = (x + dx, y + dy)
      if ny in 0..<data.len and nx in 0..<data[ny].len and data[ny][nx] == '#':
        result.inc


func nextGen(data: Data): Data =
  result = data
  for y, line in data:
    for x, cell in line:
      let nc = data.neighbors(x, y)
      if (cell == '#' and nc in [2,3]) or (cell == '.' and nc == 3):
        result[y][x] = '#'
      else:
        result[y][x] = '.'


proc setCorners(data: var Data) =
  data[0][0] = '#'
  data[0][^1] = '#'
  data[^1][0] = '#'
  data[^1][^1] = '#'


func simulate(data: Data, gens: int, corners = false): int =
  var data = data
  if corners:
    data.setCorners
  for _ in 1..gens:
    data = data.nextGen
    if corners:
      data.setCorners
  for line in data:
    result += line.count('#')


let data = parseData()

benchmark:
  echo data.simulate(100)
  echo data.simulate(100, true)
