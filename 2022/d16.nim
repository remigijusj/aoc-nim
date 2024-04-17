# Advent of Code 2022 - Day 16

import std/[strscans,strutils,sequtils,setutils,tables]
import memo
import ../utils/common

type
  Node = tuple[flow: int, name: string, adjacent: seq[string]]
  Data = Table[uint8, Node]


func parseNode(line: string): Node =
  let (_, name, flow, _, _, _, tail) =
    line.scanTuple("Valve $w has flow rate=$i; tunnel$* lead$* to valve$* $+$.")
  result.flow = flow
  result.name = name
  result.adjacent = tail.split(", ")


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for idx, line in lines:
    result[idx.uint8] = line.parseNode


func shortestPaths(data: Data): seq[seq[int]] =
  result = newSeqWith(data.len, newSeqWith(data.len, int.high))

  for i, node in data:
    result[i][i] = 0
    for j, next in data:
      if next.name in node.adjacent:
        result[i][j] = 1

  for k in data.keys:
    for i in data.keys:
      for j in data.keys:
        if result[i][k] == int.high or result[k][j] == int.high: continue
        let sum = result[i][k] + result[k][j]
        if sum < result[i][j]: result[i][j] = sum


func valves(data: Data): set[uint8] {.memoized.} =
  for i, node in data:
    if node.flow > 0: result.incl(i)


let data = parseData()
let dist = data.shortestPaths
let start = data.keys.toSeq.filterIt(data[it].name == "AA")[0]


proc maxPressure1(time: int, this: uint8, closed: set[uint8]): int {.memoized.} =
  for next in closed:
    let d = dist[this][next]
    if d < time:
      let left = time - d - 1
      let pressure1 = maxPressure1(left, next, closed - toSet([next]))
      let pressure = data[next].flow * left + pressure1
      if pressure > result: result = pressure


proc maxPressure2(time: int, this: uint8, closed: set[uint8]): int {.memoized.} =
  for next in closed:
    let d = dist[this][next]
    if d < time:
      let left = time - d - 1
      let pressure2 = maxPressure2(left, next, closed - toSet([next]))
      let pressure = data[next].flow * left + pressure2
      if pressure > result: result = pressure

  let extra = maxPressure1(26, start, closed)
  result = max(result, extra)


benchmark:
  echo maxPressure1(30, start, data.valves)
  echo maxPressure2(26, start, data.valves)
