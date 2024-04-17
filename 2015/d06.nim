# Advent of Code 2015 - Day 6

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  XY = tuple[x, y: int]

  Instruction = tuple
    what: string
    tl, br: XY

  Data = seq[Instruction]

  Grid = array[1000, array[1000, uint8]]


func parseXY(line: string): XY =
  assert line.scanf("$i,$i", result.x, result.y)


func parseInstruction(line: string): Instruction =
  let tokens = line.split(" ")
  result.what = tokens[^4]
  result.tl = tokens[^3].parseXY
  result.br = tokens[^1].parseXY


proc parseData: Data =
  readInput().strip.splitLines.map(parseInstruction)


func run1(data: Data): Grid =
  for it in data:
    for x in it.tl.x..it.br.x:
      for y in it.tl.y..it.br.y:
        case it.what
        of "on":
          result[x][y] = 1
        of "off":
          result[x][y] = 0
        of "toggle":
          result[x][y] = 1 - result[x][y]
        else:
          assert false


func run2(data: Data): Grid =
  for it in data:
    for x in it.tl.x..it.br.x:
      for y in it.tl.y..it.br.y:
        case it.what
        of "on":
          result[x][y].inc
        of "off":
          if result[x][y] > 0:
            result[x][y].dec
        of "toggle":
          result[x][y].inc(2)
        else:
          assert false


func total(grid: Grid): int =
  for x in 0..<1000:
    for y in 0..<1000:
      result += grid[x][y].int


let data = parseData()

benchmark:
  echo data.run1.total
  echo data.run2.total
