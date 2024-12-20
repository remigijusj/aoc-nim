# Advent of Code 2024 - Day 20

import std/[strutils,heapqueue,tables]
import ../utils/common

type
  XY = tuple[x, y: int]

  Item = tuple
    pos: XY
    prio: int

  Data = seq[string]

  Track = Table[XY, int]


func `+`(a, b: XY): XY {.inline.} = (a.x + b.x, a.y + b.y)

func `<`(a, b: Item): bool {.inline.} = a.prio < b.prio


proc parseData: Data =
  readInput().strip.splitLines


func findChar(data: Data, what: char): XY =
  for y, line in data:
    for x, c in line:
      if c == what:
        return (x, y)


iterator neighbors(data: Data, p: XY): XY =
  if data[p.y][p.x+1] != '#': yield (p.x+1, p.y)
  if data[p.y+1][p.x] != '#': yield (p.x, p.y+1)
  if data[p.y][p.x-1] != '#': yield (p.x-1, p.y)
  if data[p.y-1][p.x] != '#': yield (p.x, p.y-1)


func distances(data: Data): Track =
  let start = data.findChar('S')
  let finish = data.findChar('E')
  var queue: HeapQueue[Item] = [(start, 0)].toHeapQueue
  result = {start: 0}.toTable
  while queue.len > 0:
    let (this, _) = queue.pop
    if this == finish:
      break
    for next in data.neighbors(this):
      if next in result and result[next] <= result[this] + 1:
        continue
      result[next] = result[this] + 1
      queue.push (next, result[next])


func cheat(track: Track, p0, d: XY): int =
  let p2 = p0 + d + d
  if p2 in track:
    result = track[p2] - track[p0] - 2


func countCheats1(track: Track, limit: int): int =
  for this in track.keys:
    if track.cheat(this, (+1, 0)) >= limit: result.inc
    if track.cheat(this, (-1, 0)) >= limit: result.inc
    if track.cheat(this, (0, +1)) >= limit: result.inc
    if track.cheat(this, (0, -1)) >= limit: result.inc


iterator nearest(limit: int): XY =
  for dy in countup(-limit, limit):
    for dx in countup(-limit + abs(dy), limit - abs(dy)):
      yield (dx, dy)


func countCheats2(track: Track, limit: int): int =
  for this, a in track:
    for delta in nearest(20):
      let next = this + delta
      let dist = abs(delta.x) + abs(delta.y)
      let b = track.getOrDefault(next)
      if b - a - dist >= limit:
        result.inc


let data = parseData()

benchmark:
  let track = data.distances
  echo track.countCheats1(100)
  echo track.countCheats2(100)
