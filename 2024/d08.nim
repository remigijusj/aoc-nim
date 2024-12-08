# Advent of Code 2024 - Day 8

import std/[strutils,sequtils,tables,sets]
import ../utils/common

type
  XY = tuple[x, y: int]

  Data = seq[string]

  Nodes = Table[char, seq[XY]]


proc parseData: Data =
  readInput().strip.splitLines


func findNodes(data: Data): Nodes =
  for y, line in data:
    for x, c in line:
      if c == '.': continue
      discard result.hasKeyOrPut(c, @[])
      result[c].add (x, y)


# b + n * (b - a)
iterator antinodes(a, b: XY): XY =
  let d: XY = (b.x - a.x, b.y - a.y)
  var c = b
  while true:
    yield c
    c.x += d.x
    c.y += d.y


func contains(data: Data, a: XY): bool {.inline.} =
  a.x in 0..<data[0].len and a.y in 0..<data.len


proc uniqAntinodes(data: Data, nodes: Nodes, single = true): HashSet[XY] =
  for _, list in nodes:
    for a in list:
      for b in list:
        if a == b: continue
        for c in antinodes(a, b):
          if c notin data:
            break
          if single and c == b:
            continue
          result.incl(c)
          if single:
            break


let data = parseData()
let nodes = data.findNodes

benchmark:
  echo data.uniqAntinodes(nodes).card
  echo data.uniqAntinodes(nodes, false).card
