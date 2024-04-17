# Advent of Code 2023 - Day 20

import std/[strutils,sequtils,tables,deques]
from math import lcm
import ../utils/common

type
  ModuleKind = enum
    broadcaster, flipflop, conjunction

  Module = tuple
    kind: ModuleKind
    name: string
    send: seq[string]

  Data = Table[string, Module]

  PulseKind = enum
    low, high

  Pulse = tuple
    kind: PulseKind
    src, dst: string

  ModuleState = object
    case kind: ModuleKind
    of flipflop:
      on: bool
    of conjunction:
      last: Table[string, PulseKind]
    of broadcaster:
      discard

  State = Table[string, ModuleState]

const
  prefixKind = {'b': broadcaster, '%': flipflop, '&': conjunction}.toTable


func parseModule(line: string): Module =
  let parts = line.split(" -> ")
  result.kind = prefixKind[parts[0][0]]
  result.name = parts[0]
  result.name.removePrefix({'%', '&'})
  result.send = parts[1].split(", ")


proc parseData: Data =
  let modules = readInput().strip.splitLines.map(parseModule)
  for module in modules:
    result[module.name] = module


func initState(data: Data): State =
  for name, m in data:
    result[name] = ModuleState(kind: m.kind)
    if m.kind == conjunction:
      for input, m1 in data:
        if name in m1.send:
          result[name].last[input] = low


# returns which input of bb-conjunction had hit high pulse in this cycle
proc pushButton(data: Data, state: var State, counter: var array[2, int]): string =
  var queue: Deque[Pulse] = [(low, "button", "broadcaster")].toDeque
  while queue.len > 0:
    let pulse = queue.popFirst
    # specific to part one
    counter[pulse.kind.ord].inc
    if pulse.dst notin data:
      continue

    # propagation
    let this = data[pulse.dst]
    var kind = pulse.kind
    case this.kind
      of broadcaster:
        discard
      of flipflop:
        if pulse.kind == high:
          continue
        state[this.name].on = not state[this.name].on
        kind = if state[this.name].on: high else: low
      of conjunction:
        state[this.name].last[pulse.src] = pulse.kind
        kind = if state[this.name].last.values.toSeq.allIt(it == high): low else: high

    for name in this.send:
      queue.addLast (kind, this.name, name)

    # specific to part two
    if this.name == "bb":
      for key, val in state["bb"].last:
        if val == high:
          result = key


func handlePulses(data: Data, count: int): array[2, int] =
  var state = data.initState
  for _ in 1..count:
    discard data.pushButton(state, result)


# Note: count button pushes to deliver low pulse to "rx" via "bb"
func minimumPushes(data: Data): Table[string, int] =
  var state = data.initState
  var dummy: array[2, int]
  for step in 1..int.high:
    let hit = data.pushButton(state, dummy)
    if hit.len > 0 and hit notin result:
      result[hit] = step
      if result.len == 4:
        return


let data = parseData()

benchmark:
  echo data.handlePulses(1000).prod
  echo data.minimumPushes.values.toSeq.lcm
