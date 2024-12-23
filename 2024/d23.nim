# Advent of Code 2024 - Day 23

import std/[strutils,sequtils,sets,tables,algorithm]
import ../utils/common

type
  Data = seq[string]

  Nodes = HashSet[string]

  Graph = Table[string, Nodes]


proc parseData: Data =
  readInput().strip.splitLines


func buildGraph(data: Data): Graph =
  for line in data:
    let a = line[0..1]
    let b = line[3..4]
    discard result.hasKeyOrPut(a, [b].toHashSet)
    discard result.hasKeyOrPut(b, [a].toHashSet)
    result[a].incl(b)
    result[b].incl(a)


func countTriplesWith(graph: Graph, prefix: char): int =
  var single, double, triple: int
  for c, next in graph:
    if c[0] != prefix:
      continue
    for a in next:
      for b in next:
        if a < b and a in graph[b]:
          if a[0] == prefix and b[0] == prefix:
            triple.inc
          elif a[0] == prefix or b[0] == prefix:
            double.inc
          else:
            single.inc

  result = single + (double div 2) + (triple div 3)


# https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
iterator bronKerbosch(graph: Graph, r, p, x: Nodes): Nodes {.closure.} =
  if p.len == 0 and x.len == 0:
    yield r
  var p = p
  var x = x
  while p.len > 0:
    let v = p.pop
    let r1 = r.union([v].toHashSet)
    let p1 = p.intersection(graph[v])
    let x1 = x.intersection(graph[v])
    for c in graph.bronKerbosch(r1, p1, x1):
      yield c
    x.incl(v)


func findMaxClique(graph: Graph): Nodes =
  var r0, x0: Nodes
  let p0 = graph.keys.toSeq.toHashSet
  for clique in graph.bronKerbosch(r0, p0, x0):
    if clique.card > result.card:
      result = clique


func password(party: Nodes): string =
  party.items.toSeq.sorted.join(",")


let data = parseData()
let graph = data.buildGraph

benchmark:
  echo graph.countTriplesWith('t')
  echo graph.findMaxClique.password
