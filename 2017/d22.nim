# Advent of Code 2017 - Day 22

import std/[strutils,sequtils,tables]
import ../utils/common

type
  Data = seq[string]

  XY = tuple[x, y: int]

  State = enum
    clean, weakened, infected, flagged

  Grid = Table[XY, State]

  Dir = enum
    up, rt, dn, lt

  Carrier = tuple
    pos: XY
    dir: Dir


proc parseData: Data =
  readInput().strip.splitLines


func buildGrid(data: Data): Grid =
  let offset = data.len div 2
  for y, row in data:
    for x, c in row:
      if c == '#':
        result[(x-offset, y-offset)] = infected


proc mutate(state: State, delta: int): State =
  result = State.toSeq[(state.ord + delta + 4) mod 4]


proc turn(this: var Carrier, delta: int) =
  this.dir = Dir.toSeq[(this.dir.ord + delta + 4) mod 4]


proc move(this: var Carrier) =
  case this.dir:
    of up: this.pos.y.dec
    of dn: this.pos.y.inc
    of lt: this.pos.x.dec
    of rt: this.pos.x.inc


func countInfections(data: Data, bursts: int, variant: int): int =
  var grid = data.buildGrid
  var this: Carrier
  for _ in 1..bursts:
    let state = grid.getOrDefault(this.pos)
    this.turn(state.ord - 1)
    let next = state.mutate(variant)
    grid[this.pos] = next
    this.move
    if next == infected:
      result.inc


let data = parseData()

benchmark:
  echo data.countInfections(10_000, 2)
  echo data.countInfections(10_000_000, 1)
