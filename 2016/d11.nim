# Advent of Code 2016 - Day 11

import std/[sequtils,strutils,nre,tables,heapqueue]
import ../utils/common

type
  Floor = range[0..3]

  State = tuple
    elevator: int
    floor: seq[Floor] # G1, M1, G2, M2, ...

  Data = tuple
    names: seq[string]
    state: State

  Item = tuple[node: State, prio: int]


proc parseData: Data =
  let lines = readAll(stdin).strip.splitLines
  for floor, line in lines:
    for m in line.findIter(re" a (\w+)(?:-compatible)? (generator|microchip)"):
      let (name, kind) = (m.captures[0], m.captures[1])
      if name notin result.names:
        result.names.add(name)
      result.state.floor.setLen(result.names.len * 2)

      let nidx = result.names.find(name)
      let kidx = if kind == "generator": 0 else: 1
      result.state.floor[2 * nidx + kidx] = floor


func unsafe(state: State): bool =
  for m in countup(1, state.floor.len-1, 2):
    if state.floor[m-1] != state.floor[m]: # microchip not connected to own generator
      for g in countup(0, state.floor.len-1, 2):
        if state.floor[g] == state.floor[m] and g != m-1: # another generator in the same floor
          return true


# delta: +-1, oidx: indeices of objects
func modified(state: State, delta, oi1, oi2: int): State =
  result = (state.elevator + delta, state.floor)
  for oi in [oi1, oi2]:
    if oi >= 0:
      result.floor[oi].inc(delta)


iterator neighbors(state: State): State =
  var objects: seq[int]
  for oidx, floor in state.floor:
    if floor == state.elevator:
      objects.add(oidx)

  for delta in [1, -1]:
    if (delta == 1 and state.elevator == 3) or (delta == -1 and state.elevator == 0):
      continue
    for i in 0..<state.floor.len:
      if state.floor[i] == state.elevator:
        yield state.modified(delta, i, -1)
        for j in 0..<i:
          if state.floor[j] == state.elevator:
            yield state.modified(delta, i, j)


proc dist(a, b: State): int = (0..<a.floor.len).mapIt(abs(a.floor[it] - b.floor[it])).foldl(a + b)

proc `<`(a, b: Item): bool = a.prio < b.prio


func findShortest(data: Data): int =
  let start = data.state
  let finish: State = (3, repeat(3.Floor, start.floor.len))

  var moves = {start: 0}.toTable
  var queue = [(node: start, prio: 0)].toHeapQueue

  while queue.len > 0:
    let this = queue.pop
    if this.node == finish:
      return moves[finish]

    let new_move = moves[this.node] + 1
    for next in neighbors(this.node):
      if not next.unsafe and (next notin moves or new_move < moves[next]):
        moves[next] = new_move
        let prio = new_move + dist(next, finish)
        queue.push((next, prio))


var data = parseData()

benchmark:
  echo data.findShortest
benchmark:
  data.state.floor.setLen(data.state.floor.len + 4)
  echo data.findShortest # 37s
