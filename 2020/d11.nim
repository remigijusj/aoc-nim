# Advent of code 2020 - Day 11

import std/strutils
import ../utils/common

type State = object
  data: string
  width, height: int


proc parseData: State =
  result.data = readInput()
  result.width = result.data.find('\n') + 1
  result.height = result.data.count('\n')


proc move(state: State, idx: int, dir: tuple[x, y: int]): int =
  var (x, y) = (idx mod state.width, idx div state.width)
  x += dir.x
  y += dir.y
  if x < 0 or x >= state.width or y < 0 or y >= state.height:
    return -1
  else:
    return x + y * state.width


proc countNeighbors(state: State, idx: int, visibility: bool): int =
  for dir in [(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)]:
    var idx = idx
    while true:
      idx = state.move(idx, dir)
      if not visibility or idx < 0 or state.data[idx] in "L#":
        break
    if idx >= 0 and state.data[idx] == '#':
      result.inc


proc simulate(state: State, limit: int, visibility: bool): State =
  result = state
  for idx, val in state.data:
    let neighbors = state.countNeighbors(idx, visibility)
    if val == 'L' and neighbors == 0:
      result.data[idx] = '#'
    if val == '#' and neighbors >= limit:
      result.data[idx] = 'L'


proc equilibrium(state: State, limit: int, visibility: bool = false): State =
  var state = state
  while true:
    result = state.simulate(limit, visibility)
    if result == state: break
    swap(result, state)


let state = parseData()

benchmark:
  echo state.equilibrium(limit = 4).data.count('#')
  echo state.equilibrium(limit = 5, visibility = true).data.count('#')
