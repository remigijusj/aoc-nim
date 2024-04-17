# Advent of Code 2019 - Day 11

import std/[strutils, sequtils, tables]
from math import euclMod
import intcode
import ../utils/common

type
  Data = seq[int]

  Panel = tuple[x, y: int]

  Grid = Table[Panel, int]


var move: array[4, Panel] = [(0, -1), (1, 0), (0, 1), (-1, 0)]

proc `+`(a, b: Panel): Panel = (a.x + b.x, a.y + b.y)


proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


proc paintPanels(data: Data, start: int): Grid =
  var pos: Panel
  var dir: int
  var buf: seq[int]

  var ic = data.toIntcode
  ic.addInput(start)
  while not ic.halted:
    if ic.step != oOutput: continue
    buf.add(ic.popOutput)

    if buf.len == 2:
      result[pos] = buf[0]
      if buf[1] == 0: dir.dec else: dir.inc
      pos = pos + move[euclMod(dir, 4)]
      let color = result.getOrDefault(pos)
      ic.addInput(color)
      buf = @[]


proc display(grid: Grid): string =
  let points = grid.keys.toSeq
  let minx = points.mapIt(it.x).min + 1
  let maxx = points.mapIt(it.x).max - 2
  let miny = points.mapIt(it.y).min
  let maxy = points.mapIt(it.y).max
  for y in miny..maxy:
    for x in minx..maxx:
      let pixel = if grid.getOrDefault((x, y)) == 1: '#' else: ' '
      result &= pixel
    result &= "\n"


let data = parseData()

benchmark:
  echo data.paintPanels(0).len
  echo data.paintPanels(1).display.decodeBF6
