# Advent of Code 2024 - Day 4

import std/[strutils]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[string]


const
  directions = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
  crossBars = ((1, 1), (-1, -1), (1, -1), (-1, 1))


func `+`(a, b: XY): XY = (a.x + b.x, a.y + b.y)

func contains(data: Data, pos: XY): bool =
  pos.y in 0..<data.len and pos.x in 0..<data[0].len

func `[]`(data: Data, pos: XY): char =
  if pos in data: data[pos.y][pos.x] else: '~'

iterator each(data: Data): (XY, char) =
  for y, line in data:
    for x, c in line:
      yield ((x, y), c)


proc parseData: Data =
  readInput().strip.splitLines


func xmas1(data: Data, o: XY, d: XY): bool =
  data[o] == 'X' and data[o+d] == 'M' and data[o+d+d] == 'A' and data[o+d+d+d] == 'S'


func xmas2(data: Data, o: XY): bool =
  let (br, tl, tr, bl) = crossBars
  data[o] == 'A' and {data[o+tl], data[o+br]} == {'M', 'S'} and {data[o+tr], data[o+bl]} == {'M', 'S'}


proc countXmas1(data: Data): int =
  for pos, c in each(data):
    for dir in directions:
      if data.xmas1(pos, dir):
        result.inc


proc countXmas2(data: Data): int =
  for pos, c in each(data):
    if data.xmas2(pos):
      result.inc


let data = parseData()

benchmark:
  echo data.countXmas1
  echo data.countXmas2
