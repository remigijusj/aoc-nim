# Advent of Code 2018 - Day 22

import std/[strutils,strscans,heapqueue,tables]

type
  Data = object
    depth: int
    target: Cell

  Area = seq[seq[int]]

  Cell = array[2, int]

  Node = tuple[cell: Cell, tool: Tool]

  Item = tuple[node: Node, prio: int]

  Tool = range[0..2]


proc parseData: Data =
  let text = readAll(stdin).strip
  assert text.scanf("depth: $i\ntarget: $i,$i", result.depth, result.target[0], result.target[1])


template geoIndex(): int =
  if [x, y] == [0, 0] or [x, y] == data.target:
    0
  elif y == 0:
    x * 16807
  elif x == 0:
    y * 48271
  else:
    row[^1] * result[^1][x]


func buildArea(data: Data, expand = 18): Area =
  for y in 0..data.target[1] + expand:
    var row: seq[int]
    for x in 0..data.target[0] + expand:
      row.add (geoIndex() + data.depth) mod 20183
    result.add row


func totalRiskLevel(data: Data, area: Area): int =
  for row in area[0..data.target[1]]:
    for level in row[0..data.target[0]]:
      result += level mod 3


func `+`(a, b: Cell): Cell = [a[0]+b[0], a[1]+b[1]]

func `in`(cell: Cell, area: Area): bool = cell[1] in 0..area.high and cell[0] in 0..area[cell[1]].high

func `[]`(area: Area, cell: Cell): int = area[cell[1]][cell[0]]

func dist(a, b: Cell): int = abs(a[0] - b[0]) + abs(a[1] - b[1])

func `<`(a, b: Item): bool = a.prio < b.prio


iterator neighbors(area: Area, node: Node): (Node, int) =
  for delta in [[0,-1], [0,1], [1,0], [-1,0]]:
    let next = node.cell + delta
    if next in area and node.tool != area[next] mod 3:
      yield ((next, node.tool), 1)

  for other in 0..2:
    if other != node.tool and other != area[node.cell] mod 3:
      yield ((node.cell, other.Tool), 7)


func fastestWay(data: Data, area: Area): int =
  let start: Node = ([0, 0], 1.Tool) # torch
  let finish: Node = (data.target, 1.Tool)

  var times = {start: 0}.toTable
  var queue = [(node: start, prio: 0)].toHeapQueue

  while queue.len > 0:
    let this = queue.pop
    if this.node == finish:
      return times[finish]

    for next, units in area.neighbors(this.node):
      let new_time = times[this.node] + units
      if next notin times or new_time < times[next]:
        times[next] = new_time
        let prio = new_time + dist(next.cell, data.target)
        queue.push (next, prio)


let data = parseData()
let area = data.buildArea

echo data.totalRiskLevel(area)
echo data.fastestWay(area)
