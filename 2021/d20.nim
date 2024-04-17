# Advent of Code 2021 - Day 20

import std/[strutils, sequtils]
import ../utils/common

type
  Data = object
    rule: string
    grid: seq[string]


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.rule = parts[0]
  result.grid = parts[1].split("\n")


proc expand(grid: var seq[string], pad: char) =
  for row in mitems(grid):
    row.insert($pad, 0)
    row.insert($pad, row.len)
  grid.insert(pad.repeat(grid[0].len), 0)
  grid.insert(pad.repeat(grid[0].len), grid.len)


proc decode(s: string): int =
  for c in s:
    result = result * 2 + (if c == '#': 1 else: 0)


proc neighbours(grid: seq[string], ri, ci: int, filler: char): string =
  result = filler.repeat(9)
  for dri in [-1,0,1]:
    if ri + dri notin 0 ..< grid.len: continue
    for dci in [-1,0,1]:
      if ci + dci notin 0 ..< grid[0].len: continue
      let idx = (dri + 1) * 3 + (dci + 1)
      result[idx] = grid[ri + dri][ci + dci]


proc apply(grid: seq[string], rule: string, filler: char): seq[string] =
  result = newSeqWith(grid.len, newString(grid[0].len))
  for ri in 0..<grid.len:
    for ci in 0..<grid[ri].len:
      result[ri][ci] = rule[grid.neighbours(ri, ci, filler).decode]


proc simulate(data: Data, steps: int): seq[string] =
  result = data.grid
  for step in 1..steps:
    let filler = if step mod 2 == 1: '.' else: '#'
    result.expand(filler)
    result = result.apply(data.rule, filler)


proc litPixels(grid: seq[string]): int =
  result = grid.mapIt(it.count('#')).sum


let data = parseData()

benchmark:
  echo data.simulate(2).litPixels
  echo data.simulate(50).litPixels
