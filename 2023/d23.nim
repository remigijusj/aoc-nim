# Advent of Code 2023 - Day 23

import std/[strutils,sequtils,deques,sets]
import ../utils/common

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Dir = enum
    down, right, up, left

  Cursor = tuple[pos: XY, dir: Dir]

  Graph = tuple
    start, finish: XY
    edges: seq[(XY, XY, int)]

const
  moves: array[4, XY] = [(0, 1), (1, 0), (0, -1), (-1, 0)]


proc parseData: Data =
  readAll(stdin).strip.splitLines


func `+`(a, b: XY): XY = (a.x + b.x, a.y + b.y)


func contains(data: Data, pos: XY): bool =
  pos.y in 0..data.high and pos.x in 0..data[pos.y].high


func `[]`(data: Data, pos: XY): char = data[pos.y][pos.x]


func move(data: Data, cur: Cursor): Cursor =
  for delta in [0, 1, -1]:
    result.dir = Dir.toSeq[(cur.dir.ord + delta + 4) mod 4]
    result.pos = cur.pos + moves[result.dir.ord]
    if result.pos in data and data[result.pos] != '#':
      return
  assert false


func followPath(data: Data, cur: Cursor): tuple[here: XY, path: int] =
  var path = 0
  var cur = cur
  while true:
    let c = data[cur.pos]
    cur = data.move(cur)
    path.inc
    if (c in "v>" and path > 2) or cur.pos.y == data.high:
      break
  result = (cur.pos, path)


func buildGraph(data: Data): Graph =
  result.start = (1, data.low)
  result.finish = (data[^1].high-1, data.high)

  var seen: HashSet[XY]
  var queue: Deque[Cursor]
  queue.addLast (result.start, down)

  while queue.len > 0:
    let (this, dir) = queue.popFirst
    let (next, length) = data.followPath((this, dir))
    result.edges.add (this, next, length)
    if next.y == data.high or next in seen:
      continue
    seen.incl(next)
    if data[next + (1, 0)] == '>':
      queue.addLast (next, right)
    if data[next + (0, 1)] == 'v':
      queue.addLast (next, down)


func longestPath1(graph: Graph, last: XY, dist = 0): int =
  if last == graph.finish:
    return dist
  for (a, b, edge) in graph.edges:
    if a == last:
      let len = graph.longestPath1(b, dist + edge)
      if len > result: result = len


var seen: HashSet[XY]

proc longestPath2(graph: Graph, last: XY, dist = 0): int =
  if last == graph.finish:
    return dist
  seen.incl(last)
  for (a, b, edge) in graph.edges:
    if a == last and b notin seen:
      let len = graph.longestPath2(b, dist + edge)
      if len > result: result = len
    elif b == last and a notin seen:
      let len = graph.longestPath2(a, dist + edge)
      if len > result: result = len
  seen.excl(last)


let data = parseData()

benchmark:
  let graph = data.buildGraph
  echo graph.longestPath1(graph.start)
  echo graph.longestPath2(graph.start)
