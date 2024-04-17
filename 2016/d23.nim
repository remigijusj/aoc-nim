# Advent of Code 2016 - Day 23

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


proc toggle(data: var Data, idx: int) =
  if idx notin 0..<data.len:
    return
  case data[idx].op
  of "dec", "tgl":
    data[idx].op = "inc"
  of "inc":
    data[idx].op = "dec"
  of "cpy":
    data[idx].op = "jnz"
  of "jnz":
    data[idx].op = "cpy"
  else:
    assert false


# Pattern:
#   4  cpy b c
#  >5 inc a
#   6  dec c
#   7  jnz c -2
#   8  dec d
#   9  jnz d -5
# Inner loop:
#   inc1.a += cpy.a
#   dec1.a := 0
# Outer loop:
#   dec2.a times
# Result:
#   inc1.a += cpy.a * dec2.a
#   dec1.a, dec2.a := 0
#
template optimizeLoops() =
  if idx-1 >= 0 and idx+4 < data.len:
    let (cpy, inc1, dec1, jnz1, dec2, jnz2) = (data[idx-1], data[idx], data[idx+1], data[idx+2], data[idx+3], data[idx+4])

    if cpy.op == "cpy" and inc1.op == "inc" and dec1.op == "dec" and jnz1.op == "jnz" and dec2.op == "dec" and jnz2.op == "jnz" and
        cpy.b == dec1.a and dec1.a == jnz1.a and dec2.a == jnz2.a and jnz1.b.val == -2 and jnz2.b.val == -5:

      regs[inc1.a.val] += mem(cpy.a) * mem(dec2.a)
      regs[dec1.a.val] = 0
      regs[dec2.a.val] = 0
      idx += 5
      continue


func runProgram(data: Data, init: int): int =
  var data = data
  var regs = newSeq[int](4)
  regs[0] = init

  var idx = 0
  while idx in 0..<data.len:
    optimizeLoops()
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
    of "tgl":
      data.toggle(idx + mem(i.a))
    else:
      assert false
    idx.inc

  result = regs[0]


let data = parseData()

benchmark:
  echo data.runProgram(7)
  echo data.runProgram(12)
