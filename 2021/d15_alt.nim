# Advent of Code 2021 - Day 15

import std/[sequtils, tables, heapqueue]

type
  Grid = seq[seq[int]]

  Node = tuple[x, y: int]

  Item = tuple[node: Node, prio: int]


proc `[]`(grid: Grid, node: Node): int = grid[node.y][node.x]


proc parseData(filename: string): Grid =
  for line in lines(filename):
    result.add line.mapIt(it.ord - '0'.ord)


iterator neighbors(grid: Grid, n: Node): Node =
  let line = grid[n.y]
  if n.x > line.low:  yield (n.x - 1, n.y)
  if n.x < line.high: yield (n.x + 1, n.y)
  if n.y > grid.low:  yield (n.x, n.y - 1)
  if n.y < grid.high: yield (n.x, n.y + 1)


proc dist(a, b: Node): int = abs(a.x - b.x) + abs(a.y - b.y)

proc `<`(a, b: Item): bool = a.prio < b.prio


proc lowestRiskDiagonal(grid: Grid): int =
  let start = (0, 0)
  let finish = (grid[^1].high, grid.high)

  var risks = {start: 0}.toTable
  var queue = [(node: start, prio: 0)].toHeapQueue

  while queue.len > 0:
    let this = queue.pop
    if this.node == finish:
      return risks[finish]

    for next in grid.neighbors(this.node):
      let new_risk = risks[this.node] + grid[next]
      if next notin risks or new_risk < risks[next]:
        risks[next] = new_risk
        let prio = new_risk + dist(next, finish)
        queue.push((next, prio))


proc inflate(grid: Grid, times: int): Grid =
  result = grid.mapIt(it.cycle(times))
  result = result.cycle(times)

  for y, row in mpairs(result):
    for x, val in mpairs(row):
      let (cx, cy) = (x div grid.len, y div grid.len)
      val = (val + cx + cy - 1) mod 9 + 1


proc partOne(data: Grid): int = data.lowestRiskDiagonal
proc partTwo(data: Grid): int = data.inflate(5).lowestRiskDiagonal


let data = parseData("inputs/15.txt")
echo partOne(data)
echo partTwo(data)
