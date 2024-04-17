# Advent of Code 2023 - Day 25

import std/[strutils,sequtils,tables,sets]
import ../utils/common

type
  Data = seq[string]

  Graph = Table[string, HashSet[string]]


proc parseData: Data =
  readInput().strip.splitLines


func buildGraph(data: Data): Graph =
  for line in data:
    let parts = line.split(": ")
    let this = parts[0]
    let linked = parts[1].splitWhitespace.toHashSet
    if result.hasKeyOrPut(this, linked):
      result[this] = result[this] + linked
    for that in linked:
      if result.hasKeyOrPut(that, [this].toHashSet):
        result[that].incl(this)


func minCut(graph: Graph, size: int): int =
  var blob = graph.keys.toSeq[1..^1].toHashSet
  var external: CountTable[string]
  while true:
    external.clear
    for this in blob:
      external[this] = graph[this].countIt(it notin blob)
    if external.values.toSeq.sum == size:
      break
    let (that, _) = external.largest
    blob.excl(that)

  result = blob.card * (graph.len - blob.card)


let graph = parseData().buildGraph

benchmark:
  echo graph.minCut(3)
