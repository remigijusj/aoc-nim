# Advent of Code 2016 - Day 25

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
  readAll(stdin).strip.splitLines.map(parseInstruction)


template mem(rv): int =
  if rv.reg:
    regs[rv.val]
  else:
    rv.val


func runProgram(data: Data, init: int, limit: int): seq[int] =
  var data = data
  var regs = newSeq[int](4)
  regs[0] = init

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
    of "out":
      result.add mem(i.a)
      if result.len == limit:
        return
    else:
      assert false
    idx.inc


func firstAlternatingSeq(data: Data): int =
  for i in 1..int.high:
    let res = data.runProgram(i, 16) # heuristics
    if res == @[0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]:
      return i


let data = parseData()

benchmark:
  echo data.firstAlternatingSeq
