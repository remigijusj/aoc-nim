# Advent of Code 2021 - Day 2

import std/[strutils, sequtils]
import ../utils/common

type
  Instruction = tuple[cmd: string, units: int]

  Data = seq[Instruction]

  Position = tuple[horiz, depth, aim: int]


proc parseInstruction(line: string): Instruction =
  let parts = line.split(' ')
  result.cmd = parts[0]
  result.units = parts[1].parseInt


proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.parseInstruction)


proc actSimple(pos: var Position, inst: Instruction) =
  case inst.cmd:
    of "forward": pos.horiz.inc(inst.units)
    of "down": pos.depth.inc(inst.units)
    of "up": pos.depth.dec(inst.units)


proc actAimed(pos: var Position, inst: Instruction) =
  case inst.cmd:
    of "forward":
      pos.horiz.inc(inst.units)
      pos.depth.inc(pos.aim * inst.units)
    of "down": pos.aim.inc(inst.units)
    of "up": pos.aim.dec(inst.units)


proc reduce(data: Data, action: proc(pos: var Position, inst: Instruction)): Position =
  for instruction in data:
    result.action(instruction)


proc product(pos: Position): int = pos.horiz * pos.depth


let data = parseData()

benchmark:
  echo data.reduce(actSimple).product
  echo data.reduce(actAimed).product
