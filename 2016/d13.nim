# Advent of Code 2016 - Day 13

import std/[strutils,bitops,deques,sets]
import ../utils/common

type
  Data = int

  XY = tuple[x, y: int]


proc parseData: Data =
  readInput().strip.parseInt


func isWall(data: Data, this: XY): bool =
  let (x, y) = this
  let val = x*x + 3*x + 2*x*y + y + y*y + data
  return val.countSetBits mod 2 == 1


func display(data: Data, last: XY): string =
  for y in 0..last.y:
    for x in 0..last.x:
      result &= (if data.isWall((x, y)): '#' else: '.')
    result &= '\n'


iterator neighbors(data: Data, this: XY): XY =
  for dx in [-1,1]:
    let next: XY = (this.x + dx, this.y)
    if next.x >= 0 and next.y >= 0 and not data.isWall(next):
      yield next
  for dy in [-1,1]:
    let next: XY = (this.x, this.y + dy)
    if next.x >= 0 and next.y >= 0 and not data.isWall(next):
      yield next


func shortestPath(data: Data, start, finish: XY): int =
  var queue = [(0, start)].toDeque
  var seen = [start].toHashSet

  while queue.len > 0:
    let (dist, this) = queue.popFirst

    if this == finish:
      return dist

    for next in data.neighbors(this):
      if next notin seen:
        seen.incl(next)
        queue.addLast (dist+1, next)


func countReachable(data: Data, start: XY, limit: int): int =
  var queue = [(0, start)].toDeque
  var seen = [start].toHashSet

  while queue.len > 0:
    let (dist, this) = queue.popFirst
    result.inc

    for next in data.neighbors(this):
      if next notin seen and dist+1 <= limit:
        seen.incl(next)
        queue.addLast (dist+1, next)


let data = parseData()
# echo data.display((32,40))

benchmark:
  echo data.shortestPath((1,1), (31,39))
  echo data.countReachable((1,1), 50)
