# Advent of Code 2015 - Day 3

import std/[strutils,sets]
import ../utils/common

type
  Data = string

  XY = tuple[x, y: int]


proc parseData: Data =
  readAll(stdin).strip


proc move(this: var XY, c: char) =
  case c
  of '<': this.x.dec
  of '>': this.x.inc
  of '^': this.y.dec
  of 'v': this.y.inc
  else: assert false


func visited(data: Data): HashSet[XY] =
  var this: XY
  result.incl(this)
  for c in data:
    this.move(c)
    result.incl(this)


func half(data: string, offset: int): string =
  result = newStringOfCap(data.len div 2)
  for i in countup(offset, data.high, 2):
    result.add data[i]


let data = parseData()

benchmark:
  echo data.visited.card
  echo (data.half(0).visited + data.half(1).visited).card
