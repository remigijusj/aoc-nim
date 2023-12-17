# Advent of Code 2023 - Day 17

import std/[strutils,sequtils,heapqueue,tables]
import ../utils/common

type
  Data = seq[seq[int]]

  Dir = enum
    right, down, left, up

  XY = tuple[x, y: int]

  Node = tuple[pos: XY, dir: Dir, steps: int]

  Item = tuple[node: Node, prio: int]

const
  delta = [(1, 0), (0, 1), (-1, 0), (0, -1)]


func parseRow(line: string): seq[int] =
  line.mapIt(it.ord - '0'.ord)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseRow)


func opposite(a, b: Dir): bool {.inline.} = (a.ord - b.ord).abs == 2

func `<`(a, b: Item): bool {.inline.} = a.prio < b.prio

func dist(a, b: XY): int {.inline.} = (a.x - b.x).abs + (a.y - b.y).abs


func contains(data: Data, pos: XY): bool =
  pos.x in 0..<data[0].len and pos.y in 0..<data.len


iterator neighbors(data: Data, pos: XY): (XY, Dir) =
  for dir in Dir.toSeq:
    let (dx, dy) = delta[dir.ord]
    yield ((pos.x + dx, pos.y + dy), dir)


func lowestLoss(data: Data, smin, smax: int): int =
  var start: Node = ((0, 0), right, -1)
  var finish: XY = (data[^1].high, data.high)

  var loss = {start: 0}.toTable
  var queue = [(node: start, prio: 0)].toHeapQueue

  while queue.len > 0:
    let (this, _) = queue.pop
    if this.pos == finish and this.steps >= smin:
      return loss[this]

    for (pos, dir) in data.neighbors(this.pos):
      if pos notin data or opposite(this.dir, dir):
        continue

      let steps = if dir == this.dir: this.steps + 1 else: 0
      if steps > smax or (steps == 0 and smin > 0 and this.steps in 0..<smin):
        continue

      let next = (pos, dir, steps).Node
      let lossNext = loss[this] + data[pos.y][pos.x]
      if next in loss and loss[next] <= lossNext:
        continue

      loss[next] = lossNext
      let prio = dist(pos, finish) + lossNext
      queue.push (next, prio)


let data = parseData()

benchmark:
  echo data.lowestLoss(0, 2)
  echo data.lowestLoss(3, 9)
