# Advent of Code 2022 - Day 24

import std/[strutils,heapqueue,sets,math]

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Node = tuple[xy : XY, time: int]

  Item = tuple[node: Node, prio: int]


func `<`(a, b: Item): bool = a.prio < b.prio

func dist(a, b: XY): int = (a.x - b.x).abs + (a.y - b.y).abs


proc parseData: Data =
  readAll(stdin).strip.splitLines


iterator neighbors(data: Data, pos: XY): XY =
  let line = data[pos.y]
  if pos.x > line.low:  yield (pos.x - 1, pos.y)
  if pos.x < line.high: yield (pos.x + 1, pos.y)
  if pos.y > data.low:  yield (pos.x, pos.y - 1)
  if pos.y < data.high: yield (pos.x, pos.y + 1)
  yield pos


func norm(val, max: int): int {.inline.} =
  1 + euclMod(val - 1, max)


func blizzard(data: Data, node: Node): bool =
  let (x, y) = node.xy
  data[y][norm(x - node.time, data[0].len-2)] == '>' or
  data[y][norm(x + node.time, data[0].len-2)] == '<' or
  data[norm(y - node.time, data.len-2)][x] == 'v' or
  data[norm(y + node.time, data.len-2)][x] == '^'


proc shortestPath(data: Data, time = 0, backwards = false): int =
  var start: XY = (data[0].find('.'), 0)
  var finish: XY = (data[^1].find('.'), data.high)
  if backwards:
    swap start, finish

  var seen: HashSet[Node]
  var queue = [(node: (start, time).Node, prio: 0)].toHeapQueue
  while queue.len > 0:
    let (this, _) = queue.pop
    if this.xy == finish:
       return this.time

    for xy1 in data.neighbors(this.xy):
      let next = (xy1, this.time + 1).Node
      if data[xy1.y][xy1.x] == '#' or data.blizzard(next) or next in seen:
        continue
      let prio = dist(xy1, finish) + next.time
      queue.push (next, prio)
      seen.incl next


proc shortestPathX3(data: Data): int =
  result = data.shortestPath(0)
  result = data.shortestPath(result, true)
  result = data.shortestPath(result)


let data = parseData()

echo data.shortestPath
echo data.shortestPathX3
