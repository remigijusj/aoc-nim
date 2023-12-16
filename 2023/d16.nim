# Advent of Code 2023 - Day 16

import std/[strutils,sequtils,tables,deques]
import ../utils/common

type
  XY = tuple[x, y: int]

  Dir = enum
    left, down, right, up

  Beam = tuple
    pos: XY
    dir: Dir

  Data = seq[string]


const delta = [(-1, 0), (0, 1), (1, 0), (0, -1)]


proc parseData: Data =
  readAll(stdin).strip.splitLines


func contains(data: Data, pos: XY): bool =
  pos.x in 0..<data[0].len and pos.y in 0..<data.len


func `[]`(data: Data, pos: XY): char =
  data[pos.y][pos.x]


func next(pos: XY, dir: Dir): XY =
  let (dx, dy) = delta[dir.ord]
  result = (pos.x + dx, pos.y + dy)


iterator shine(here: char, dir: Dir): Dir =
  case here
  of '/':
    yield [down, left, up, right][dir.ord]

  of '\\':
    yield [up, right, down, left][dir.ord]

  of '|':
    case dir
    of left, right:
      yield up
      yield down
    else:
      yield dir

  of '-':
    case dir
    of up, down:
      yield left
      yield right
    else:
      yield dir

  else:
    yield dir


func energized(data: Data, start: Beam): Table[XY, set[Dir]] =
  var light = [start].toDeque
  while light.len > 0:
    let beam = light.popFirst
    if beam.pos in result and beam.dir in result[beam.pos]:
      continue
    discard result.hasKeyOrPut(beam.pos, {})
    result[beam.pos].incl(beam.dir)
    for dir in data[beam.pos].shine(beam.dir):
      let pos = next(beam.pos, dir)
      if pos in data:
        light.addLast((pos, dir))


iterator edges(data: Data): Beam =
  for x in 0..<data[0].len:
    yield ((x, 0), down)
    yield ((x, data.len-1), up)
  for y in 0..<data.len:
    yield ((0, y), right)
    yield ((data[0].len-1, y), left)


let data = parseData()

benchmark:
  echo data.energized(((0, 0), right)).len
  echo data.edges.toSeq.mapIt(data.energized(it).len).max
