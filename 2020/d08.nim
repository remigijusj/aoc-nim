# Advent of code 2020 - Day 8

import strutils, sequtils

type Kind = enum
  acc, jmp, nop

type Instruction = object
  kind: Kind
  delta: int

proc parseInstruction(line: string): Instruction =
  result.kind = parseEnum[Kind](line[0..2])
  result.delta = parseInt(line[4..^1])


proc instructionsList(filename: string): seq[Instruction] =
  for line in lines(filename):
    result.add parseInstruction(line)


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


proc computeFixed(list: seq[Instruction]): int =
  var list = list
  for idx, instr in mpairs(list):
    if instr.flip:
      let (acc, repeat) = list.runCalc
      discard instr.flip
      if not repeat:
        return acc


proc partOne(list: seq[Instruction]): int = list.runCalc.accum
proc partTwo(list: seq[Instruction]): int = list.computeFixed


let list = instructionsList("inputs/08.txt")
echo partOne(list)
echo partTwo(list)
