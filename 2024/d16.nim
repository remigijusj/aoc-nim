# Advent of Code 2024 - Day 16

import std/[strutils,heapqueue,tables,sets]
import ../utils/common

type
  XY = tuple[x, y: int]

  Dir = enum
    east, south, west, north

  Node = tuple
    pos: XY
    dir: Dir

  Item = tuple[node: Node, score: int]

  Data = seq[string]

const
  delta: array[4, XY] = [(1, 0), (0, 1), (-1, 0), (0, -1)]


func `+`(a, b: XY): XY = (a.x + b.x, a.y + b.y)

func left(a: Dir): Dir = [north, east, south, west][a.ord]

func right(a: Dir): Dir = [south, west, north, east][a.ord]

func `<`(a, b: Item): bool {.inline.} = a.score < b.score


proc parseData: Data =
  readInput().strip.splitLines


func findChar(data: Data, what: char): XY =
  for y, line in data:
    for x, c in line:
      if c == what:
        return (x, y)


func neighbor(pos: XY, dir: Dir): XY =
  pos + delta[dir.ord]


iterator neighbors(data: Data, this: Node): Node =
  let next = this.pos.neighbor(this.dir)
  if data[next.y][next.x] != '#':
    yield (next, this.dir)

  let left = this.pos.neighbor(this.dir.left)
  if data[left.y][left.x] != '#':
    yield (left, this.dir.left)

  let right = this.pos.neighbor(this.dir.right)
  if data[right.y][right.x] != '#':
    yield (right, this.dir.right)


proc tracePaths(data: Data): (int, int) =
  let start = data.findChar('S')
  let finish = data.findChar('E')

  var queue: HeapQueue[Item] = [((start, east), 0)].toHeapQueue
  var score: Table[Node, int] = {(start, east): 0}.toTable
  var comes: Table[Node, seq[Node]]
  var final: Node

  while queue.len > 0:
    let (this, _) = queue.pop
    if this.pos == finish:
      final = this
      break

    for next in data.neighbors(this):
      let scoreNext = score[this] + (if next.dir == this.dir: 1 else: 1001)

      # Important to manage back-links
      discard comes.hasKeyOrPut(next, @[])
      if next in score:
        if scoreNext > score[next]:
          continue
        elif scoreNext == score[next]:
          comes[next].add(this)
          continue
        elif scoreNext < score[next]:
          comes[next] = @[this]
      else:
        comes[next].add(this)

      score[next] = scoreNext
      queue.push (next, scoreNext)

  # Trace back the best paths, collect tiles
  var tiles: HashSet[XY]
  var front = [final].toHeapQueue
  while front.len > 0:
    let this = front.pop
    tiles.incl(this.pos)
    for next in comes.getOrDefault(this):
      if next.pos notin tiles:
        front.push(next)

  result = (score[final], tiles.card)


let data = parseData()

benchmark:
  let (score, tiles) = data.tracePaths
  echo score
  echo tiles
