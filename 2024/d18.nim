# Advent of Code 2024 - Day 18

import std/[strscans,strutils,sequtils,heapqueue,sets,tables]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[XY]

  Grid = HashSet[XY]

  Item = tuple
    pos: XY
    prio: int

const
  xm = 70
  ym = 70
  start = (0, 0)
  finish = (xm, ym)


func `$`(a: XY): string = format("$#,$#", a.x, a.y)

func `<`(a, b: Item): bool {.inline.} = a.prio < b.prio


func parseBlock(line: string): XY =
  assert line.scanf("$i,$i", result.x, result.y)


proc parseData: Data =
  readInput().strip.splitLines.map(parseBlock)


iterator neighbors(this: XY): XY =
  if this.x < xm: yield (this.x+1, this.y)
  if this.y < ym: yield (this.x, this.y+1)
  if this.x >  0: yield (this.x-1, this.y)
  if this.y >  0: yield (this.x, this.y-1)


func shortestPath(grid: Grid): int =
  var dist = {start: 0}.toTable
  var queue: HeapQueue[Item] = [(start, 0)].toHeapQueue

  while queue.len > 0:
    let (this, _) = queue.pop
    if this == finish:
      return dist[finish]

    for next in neighbors(this):
      if next in grid:
        continue
      if next in dist and dist[next] <= dist[this] + 1:
        continue
      dist[next] = dist[this] + 1
      queue.push (next, dist[next])


func forFirst(data: Data, limit: int): Grid =
  data[0..<limit].toHashSet


func findBlocking(data: Data, limit: int): string =
  var a = limit
  var b = data.len
  while b - a > 1:
    let this = (a + b) div 2
    let grid = data.forFirst(this)
    if grid.shortestPath == 0:
      b = this
    else:
      a = this

  result = $(data[b-1])


let data = parseData()

benchmark:
  echo data.forFirst(1024).shortestPath
  echo data.findBlocking(1024)
