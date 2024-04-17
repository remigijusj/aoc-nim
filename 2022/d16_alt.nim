# Advent of Code 2022 - Day 16

import std/[strscans,strutils,sequtils,tables,math,bitops,algorithm]
import ../utils/common

type
  Node = tuple[flow: uint8, name: string, adjacent: seq[string]]
  Data = Table[string, Node]
  Dist = Table[string, int]
  State = tuple[time: uint8, node: uint8, closed: uint16]


func parseNode(line: string): Node =
  let (_, name, flow, _, _, _, tail) =
    line.scanTuple("Valve $w has flow rate=$i; tunnel$* lead$* to valve$* $+$.")
  result.flow = flow.uint8
  result.name = name
  result.adjacent = tail.split(", ")


proc parseData: Data =
  for line in readInput().strip.splitLines:
    let node = line.parseNode
    result[node.name] = node


func shortestPaths(data: Data): Dist =
  for i, node in data:
    result[i & i] = 0
    for j in node.adjacent:
      result[i & j] = 1

  for k in data.keys:
    for i in data.keys:
      for j in data.keys:
        if not (i & k in result and k & j in result): continue
        if result[i & k] + result[k & j] < result.getOrDefault(i & j, int.high):
          result[i & j] = result[i & k] + result[k & j]


func transformMatrix(dist: Dist, nodes: seq[string]): seq[seq[uint8]] =
  result = newSeqWith(nodes.len+1, newSeqWith(nodes.len+1, 0'u8))

  for i, this in nodes:
    for j, that in nodes:
      result[i][j] = dist[this & that].uint8 + 1'u8

  for i, this in nodes:
    result[nodes.len][i] = dist["AA" & this].uint8 + 1'u8


func packs(s: State): uint32 {.inline.} =
  result = s.time.uint32 or (s.node.uint32 shl 5) or (s.closed.uint32 shl 9)


func unpacks(u: uint32): State {.inline.} =
  (u.masked(0..4).uint8, (u.masked(5..8) shr 5).uint8, (u shr 9).uint16)


let data = parseData()
let nodes = data.keys.toSeq.filterIt(data[it].flow > 0).sorted
let flows = nodes.mapIt(data[it].flow)
let dist = data.shortestPaths.transformMatrix(nodes)

var cache1: array[2^24, uint16]
var cache2: array[2^24, uint16]
cache1.fill(uint16.high)
cache2.fill(uint16.high)

proc maxPressure1(s: uint32): uint16 =
  if cache1[s] < uint16.high: return cache1[s]

  let (time, this, closed) = unpacks(s)
  for next in 0'u8 ..< nodes.len.uint8:
    if closed.testBit(next):
      let d = dist[this][next]
      if d < time:
        let left = time - d
        let closed1 = closed xor (1'u16 shl next)
        let pressure1 = maxPressure1(packs (left, next, closed1))
        let pressure = flows[next].uint16 * left.uint16 + pressure1
        if pressure > result:
          result = pressure

  cache1[s] = result


proc maxPressure2(s: uint32): uint16 =
  if cache2[s] < uint16.high: return cache1[s]

  let (time, this, closed) = unpacks(s)
  for next in 0'u8 ..< nodes.len.uint8:
    if closed.testBit(next):
      let d = dist[this][next]
      if d < time:
        let left = time - d
        let closed2 = closed.xor (1'u16 shl next)
        let pressure2 = maxPressure2(packs (left, next, closed2))
        let pressure = flows[next].uint16 * left.uint16 + pressure2
        if pressure > result:
          result = pressure

  let extra = maxPressure1(packs (26'u8, nodes.len.uint8, closed))
  result = max(result, extra)

  cache2[s] = result


benchmark:
  echo maxPressure1(packs (30'u8, nodes.len.uint8, (2^nodes.len-1).uint16))
  echo maxPressure2(packs (26'u8, nodes.len.uint8, (2^nodes.len-1).uint16))
