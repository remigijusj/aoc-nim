# Advent of Code 2022 - Day 12

import std/[strutils,deques,sets]

type Data = object
  rw, start, finish: int
  grid: string


proc parseData: Data =
  let data = readAll(stdin)
  result.rw = data.find('\n')
  result.grid = data.replace("\n", "")
  result.start = result.grid.find('S')
  result.finish = result.grid.find('E')
  result.grid = result.grid.multiReplace(("S","a"),("E","z"))


iterator neighbors(data: Data, pos: int): int =
  if pos mod data.rw > 0:         yield pos-1
  if pos mod data.rw < data.rw-1: yield pos+1
  if pos-data.rw >= 0:            yield pos-data.rw
  if pos+data.rw < data.grid.len: yield pos+data.rw


func shortestPath(data: Data, start = true): int =
  var queue = [(0, data.finish)].toDeque
  var seen = [data.finish].toHashSet
  result = int.high

  while queue.len > 0:
    let (dist, this) = queue.popFirst

    if start:
      if this == data.start: return dist
    elif data.grid[this] == 'a':
      if dist < result: result = dist

    for next in data.neighbors(this):
      if data.grid[this] > data.grid[next].succ:
        continue

      if next notin seen:
        seen.incl(next)
        queue.addLast (dist+1, next)


let data = parseData()

let part1 = data.shortestPath
let part2 = data.shortestPath(false)

echo part1
echo part2
