# Advent of Code 2021 - Day 25

import std/[strutils, sequtils]

type Data = seq[string]


proc parseData(filename: string): Data =
  readFile(filename).strip.split("\n")


proc moveEast(grid: var Data): int =
  let w = grid[0].len
  let h = grid.len
  var move = newSeqWith(h, newSeqWith(w, false))

  for y, row in grid:
    for x, c in row:
      if c == '>':
        if row[(x+1) mod w] == '.':
          move[y][x] = true
          result.inc

  for y, row in move:
    for x, b in row:
      if b:
        grid[y][x] = '.'
        grid[y][(x+1) mod w] = '>'


proc moveSouth(grid: var Data): int =
  let w = grid[0].len
  let h = grid.len
  var move = newSeqWith(h, newSeqWith(w, false))

  for y, row in grid:
    for x, c in row:
      if c == 'v':
        if grid[(y+1) mod h][x] == '.':
          move[y][x] = true
          result.inc

  for y, row in move:
    for x, b in row:
      if b:
        grid[y][x] = '.'
        grid[(y+1) mod h][x] = 'v'


proc simulate(data: Data): int =
  var grid = data
  for step in countup(1, int.high):
    let count = grid.moveEast + grid.moveSouth
    if count == 0: return step


proc partOne(data: Data): int = data.simulate


let data = parseData("inputs/25.txt")
echo partOne(data)
