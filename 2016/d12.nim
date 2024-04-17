# Advent of Code 2016 - Day 12

import std/[strutils,sequtils]
import ../utils/common

type
  RegVal = object
    reg: bool
    val: int

  Instruction = tuple
    op: string
    a, b: RegVal

  Data = seq[Instruction]


proc parseRegVal(line: string): RegVal =
  if line[0] in 'a'..'d':
    result = RegVal(reg: true, val: line[0].ord - 'a'.ord)
  else:
    result = RegVal(reg: false, val: line.parseInt)


func parseInstruction(line: string): Instruction =
  let parts = line.split(" ")
  result.op = parts[0]
  result.a = parts[1].parseRegVal
  if parts.len > 2:
    result.b = parts[2].parseRegVal


proc parseData: Data =
  readInput().strip.splitLines.map(parseInstruction)


template mem(rv): int =
  if rv.reg:
    regs[rv.val]
  else:
    rv.val


func runProgram(data: Data, init = false): int =
  var regs = newSeq[int](4)
  if init:
    regs[2] = 1
  var idx = 0
  while idx in 0..<data.len:
    let i = data[idx]
    case i.op
    of "cpy":
      regs[i.b.val] = mem(i.a)
    of "dec":
      regs[i.a.val].dec
    of "inc":
      regs[i.a.val].inc
    of "jnz":
      if mem(i.a) != 0:
        idx += mem(i.b)
        continue
    else:
      assert false
    idx.inc

  result = regs[0]


let data = parseData()

benchmark:
  echo data.runProgram
  echo data.runProgram(true)
