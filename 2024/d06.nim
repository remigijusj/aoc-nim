# Advent of Code 2024 - Day 6

import std/[strutils]
import bitty
import ../utils/common

type
  XY = tuple[x, y: int]

  Dir = enum
    up, right, down, left

  Data = seq[string]

  Path = array[4, BitArray2d]

  Trace = tuple
    path: Path
    loop: bool


proc parseData: Data =
  readInput().strip.splitLines


iterator cells(data: Data): (XY, char) =
  for y, line in data:
    for x, c in line:
      yield ((x, y), c)


func findGuard(data: Data): XY =
  for pos, c in data.cells:
    if c == '^':
      return pos


func `[]`(data: Data, pos: XY): char {.inline.} =
  data[pos.y][pos.x]


func contains(data: Data, pos: XY): bool {.inline.} =
  pos.y in 0..<data.len and pos.x in 0..<data[0].len


func rotate(dir: Dir): Dir {.inline.} =
  if dir == left: up else: dir.succ


func move(pos: XY, dir: Dir): XY {.inline.} =
  result = pos
  case dir
    of up:    result.y.dec
    of right: result.x.inc
    of down:  result.y.inc
    of left:  result.x.dec


func traceGuard(data: var Data, start: XY): Trace =
  for i in 0..3:
    result.path[i] = newBitArray2d(data[0].len, data.len)

  var this = start
  var face = up

  while this in data:
    if result.path[face.ord][this.y, this.x]:
      result.loop = true
      break
    result.path[face.ord][this.y, this.x] = true

    let next = this.move(face)
    if next notin data:
      break
    elif data[next] == '#':
      face = face.rotate
    else:
      this = next


func countLoops(data: var Data, path: BitArray2d, start: XY): int =
  for pos, _ in data.cells:
    if pos == start or not path[pos.y, pos.x]:
      continue
    data[pos.y][pos.x] = '#'
    if data.traceGuard(start).loop:
      result.inc
    data[pos.y][pos.x] = '.'


var data = parseData()

benchmark:
  let start = data.findGuard
  let trace = data.traceGuard(start)
  let path = trace.path[0] or trace.path[1] or trace.path[2] or trace.path[3]
  echo count($(path), '1') # hack, bitty missing BitArray2d#count
  echo data.countLoops(path, start)
