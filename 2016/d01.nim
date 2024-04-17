# Advent of Code 2016 - Day 1

import std/[strutils,sequtils,sets]
import ../utils/common

type
  Step = tuple[turn, dist: int]

  Data = seq[Step]

  Dir = enum
    north, east, south, west

  XY = tuple[x, y: int]


func parseStep(line: string): Step =
  assert line[0] in "LR"
  result.turn = "LR".find(line[0]) * 2 - 1
  result.dist = line[1..^1].parseInt


proc parseData: Data =
  readInput().strip.split(", ").map(parseStep)


func dist(pos: XY): int =
  result = pos.x.abs + pos.y.abs


func change(face: Dir, turn: int): Dir =
  result = ((face.ord + turn + 4) mod 4).Dir


func run(data: Data, stopEarly = false): XY =
  var face = north
  var seen = [result].toHashSet

  for (turn, dist) in data:
    face = face.change(turn)
    for _ in 0..<dist:
      case face
        of north: result.y.inc
        of south: result.y.dec
        of east:  result.x.inc
        of west:  result.x.dec

      if stopEarly:
        if result in seen:
          return
        else:
          seen.incl(result)


let data = parseData()

benchmark:
  echo data.run.dist
  echo data.run(true).dist
