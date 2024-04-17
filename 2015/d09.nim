# Advent of Code 2015 - Day 9

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

const N = 8

type
  Edge = tuple[a, b: string, dist: int]

  Data = seq[Edge]

  Matrix = array[N, array[N, int]]


func parseEdge(line: string): Edge =
  assert line.scanf("$+ to $+ = $i", result.a, result.b, result.dist)


proc parseData: Data =
  readInput().strip.splitLines.map(parseEdge)


func adjacencyMatrix(data: Data): Matrix =
  var names: seq[string]
  for (a, b, dist) in data:
    if a notin names: names.add(a)
    if b notin names: names.add(b)
    let (ai, bi) = (names.find(a), names.find(b))
    result[ai][bi] = dist
    result[bi][ai] = dist


func distance(graph: Matrix, order: seq[int]): int =
  for i in 1..<N:
    result += graph[order[i-1]][order[i]]


iterator routes(graph: Matrix): int =
  var order = toSeq(0..<N)
  yield graph.distance(order)
  while order.nextPermutation:
    yield graph.distance(order)


let data = parseData()
let graph = data.adjacencyMatrix

benchmark:
  echo graph.routes.toSeq.min
  echo graph.routes.toSeq.max
