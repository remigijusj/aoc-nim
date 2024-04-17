# Advent of Code 2017 - Day 12

import std/[strutils,sequtils,sets,tables]
import ../utils/common

type Data = Table[int, seq[int]]


proc parseData: Data =
  for line in readInput().strip.splitLines:
    let parts = line.split(" <-> ")
    let node = parseInt(parts[0])
    result[node] = parts[1].split(", ").mapIt(it.parseInt)


func component(data: Data, node: int): HashSet[int] =
  var stack = @[node]
  while stack.len > 0:
    let node = stack.pop
    result.incl(node)
    for next in data[node]:
      if next notin result:
        stack.add(next)


func componentsCount(data: Data): int =
  var nodes = data.keys.toSeq.toHashSet
  while nodes.card > 0:
    let node = nodes.pop
    nodes = nodes - data.component(node)
    result.inc


let data = parseData()

benchmark:
  echo data.component(0).card
  echo data.componentsCount
