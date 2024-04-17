# Advent of code 2020 - Day 12

import std/[strutils, sequtils]
import ../utils/common

# x facing east, y facing north
const DIR = [(x: 1, y: 0), (x: 0, y: 1), (x: -1, y: 0), (x: 0, y: -1)]

type
  State = object
    x, y: int
    dir: int
    wayX, wayY: int

  Step = tuple[kind: char, value: int]

  Data = seq[Step]


proc parseStep(line: string): Step =
  (line[0], parseInt(line[1..^1]))


proc parseData: Data =
  readInput().strip.splitLines.map(parseStep)


proc run1(state: var State, step: Step) =
  case step.kind:
  of 'N': state.y += step.value
  of 'S': state.y -= step.value
  of 'E': state.x += step.value
  of 'W': state.x -= step.value
  of 'L': state.dir = (state.dir + 1 * (step.value div 90)) mod 4
  of 'R': state.dir = (state.dir + 3 * (step.value div 90)) mod 4
  of 'F':
    state.x += DIR[state.dir].x * step.value
    state.y += DIR[state.dir].y * step.value
  else: discard


proc rotate(state: var State, times: int) =
  for i in 0..<times:
    (state.wayX, state.wayY) = (-state.wayY, state.wayX)


proc run2(state: var State, step: Step) =
  case step.kind:
  of 'N': state.wayY += step.value
  of 'S': state.wayY -= step.value
  of 'E': state.wayX += step.value
  of 'W': state.wayX -= step.value
  of 'L': rotate(state, step.value div 90)
  of 'R': rotate(state, 4-(step.value div 90))
  of 'F':
    state.x += state.wayX * step.value
    state.y += state.wayY * step.value
  else: discard


proc simulate(list: Data, run: proc(state: var State, step: Step)): State =
  result = State(wayX: 10, wayY: 1)
  for step in list:
    run(result, step)


proc manhattan(state: State): int = state.x.abs + state.y.abs


let data = parseData()

benchmark:
  echo data.simulate(run1).manhattan
  echo data.simulate(run2).manhattan
