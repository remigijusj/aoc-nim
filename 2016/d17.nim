# Advent of Code 2016 - Day 17

import std/[strutils,deques,sets]
import checksums/md5
import ../utils/common

type
  XY = tuple[x, y: int] # 0..3

  Delta = tuple[dx, dy: range[-1..1]]

  Item = tuple[here: XY, path: string]


const
  Dirs = "UDLR"

  Deltas: array[4, Delta] = [(0,-1),(0,1),(-1,0),(1,0)]


proc parseData: string =
  readInput().strip


iterator neighbors(data: string, here: XY, path: string): tuple[next: XY, move: char] =
  let hash = getMD5(data & path)
  for i in 0..3:
    if hash[i] in 'b'..'f':
      let delta = Deltas[i]
      let next: XY = (here.x + delta.dx, here.y + delta.dy)
      if next.x in 0..3 and next.y in 0..3:
        yield (next, Dirs[i])


iterator allPaths(data: string): string =
  let first: Item = (here: (0, 0), path: "")
  let vault: XY = (3, 3)

  var queue = [first].toDeque
  while queue.len > 0:
    let (this, path) = queue.popFirst
    if this == vault:
      yield path
    else:
      for next, move in data.neighbors(this, path):
        queue.addLast (next, path & move)


proc shortestPath(data: string): string =
  for path in data.allPaths:
    return path


proc longestPath(data: string): int =
  for path in data.allPaths:
    if path.len > result:
      result = path.len


let data = parseData()

benchmark:
  echo data.shortestPath
  echo data.longestPath
