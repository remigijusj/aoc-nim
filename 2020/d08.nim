# Advent of code 2020 - Day 8

import std/[strutils, sequtils]
import ../utils/common

type
  Kind = enum
    acc, jmp, nop

  Instruction = object
    kind: Kind
    delta: int

  Data = seq[Instruction]


proc parseInstruction(line: string): Instruction =
  result.kind = parseEnum[Kind](line[0..2])
  result.delta = parseInt(line[4..^1])


proc parseData: Data =
  readInput().strip.splitLines.map(parseInstruction)


proc step(instruction: Instruction, idx, accum: var int) =
  case instruction.kind:
    of nop:
      idx.inc
    of acc:
      idx.inc
      accum += instruction.delta
    of jmp:
      idx += instruction.delta


proc runCalc(list: seq[Instruction]): tuple[accum: int, repeat: bool] =
  var idx: int
  var visited = newSeq[bool](list.len)
  while idx in 0..<list.len:
    if visited[idx]:
      result.repeat = true
      break
    visited[idx] = true
    list[idx].step(idx, result.accum)


proc flip(instruction: var Instruction): bool =
  case instruction.kind
    of nop: instruction.kind = jmp
    of jmp: instruction.kind = nop
    of acc: return false
  true


proc computeFixed(list: Data): int =
  var list = list
  for idx, instr in mpairs(list):
    if instr.flip:
      let (acc, repeat) = list.runCalc
      discard instr.flip
      if not repeat:
        return acc


let data = parseData()

benchmark:
  echo data.runCalc.accum
  echo data.computeFixed
