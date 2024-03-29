# Advent of Code 2015 - Day 23

import std/[strutils,sequtils]
import ../utils/common

type
  Instruction = tuple
    op: string
    id, offset: int

  Data = seq[Instruction]


func parseInstruction(line: string): Instruction =
  let parts = line.split(' ')
  result.op = parts[0]
  result.id = "ab".find(parts[1][0])
  if result.op[0] == 'j':
    result.offset = parseInt(if parts.len == 3: parts[2] else: parts[1])


func runProgram(data: Data, init: int): int =
  var regs: array[2, int]
  regs[0] = init
  var idx = 0
  while idx in 0..<data.len:
    let x = data[idx]
    case x.op
    of "hlf":
      regs[x.id] = regs[x.id] div 2
    of "tpl":
      regs[x.id] = regs[x.id] * 3
    of "inc":
      regs[x.id].inc
    of "jmp":
      idx += x.offset
      continue
    of "jie":
      if regs[x.id] mod 2 == 0:
        idx += x.offset
        continue
    of "jio":
      if regs[x.id] == 1:
        idx += x.offset
        continue
    else:
      assert false
    idx.inc

  result = regs[1]


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInstruction)


let data = parseData()

benchmark:
  echo data.runProgram(0)
  echo data.runProgram(1)
