# Advent of Code 2019 - Day 3

import std/[strutils, sequtils, sets, tables]

type Line = tuple[dir: char, move: int]

type Wire = seq[Line]

type Data = seq[Wire]

type Point = tuple[x, y: int]

type Trace = Table[Point, int]

# 2 traces and intersection set
type Inter = tuple[t0, t1: Trace, inter: HashSet[Point]]


proc parseLine(str: string): Line =
  result.dir = str[0]
  result.move = str[1..^1].parseInt


proc parseData(filename: string): Data =
  for line in readFile(filename).strip.split("\n"):
    result.add line.split(",").mapIt(it.parseLine)


proc moveBy(pt: var Point, line: Line) =
  case line.dir
  of 'L': pt.x.dec
  of 'R': pt.x.inc
  of 'U': pt.y.dec
  of 'D': pt.y.inc
  else: return


proc traceWire(wire: Wire): Table[Point, int] =
  var pt: Point = (0, 0)
  var step: int = 0
  for line in wire:
    for i in 1..line.move:
      pt.moveBy(line)
      step.inc
      discard result.hasKeyOrPut(pt, step)


proc tracesIntersection(data: Data): Inter =
  result.t0 = traceWire(data[0])
  result.t1 = traceWire(data[1])
  for pt in keys(result.t0):
    if pt in result.t1:
      result.inter.incl pt


proc partOne(inter: Inter): int =
  result = int.high
  for pt in inter.inter:
    let dist = pt.x.abs + pt.y.abs
    if dist < result: result = dist


proc partTwo(inter: Inter): int =
  result = int.high
  for pt in inter.inter:
    let comb = inter.t0[pt] + inter.t1[pt]
    if comb < result: result = comb


let data = parseData("inputs/03.txt")
let inter = data.tracesIntersection

echo partOne(inter)
echo partTwo(inter)
