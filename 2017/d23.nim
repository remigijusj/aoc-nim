# Advent of Code 2017 - Day 23

import std/[strutils,sequtils]

type
  RegVal = object
    reg: bool
    val: int

  Instruction = tuple
    op: string
    a, b: RegVal

  Data = seq[Instruction]


proc parseRegVal(line: string): RegVal =
  if line[0] in 'a'..'h':
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


func runProgram(data: Data): int =
  var regs = newSeq[int](8)
  var idx = 0
  while idx in 0..<data.len:
    let i = data[idx]
    case i.op
    of "set":
      regs[i.a.val] = mem(i.b)
    of "sub":
      regs[i.a.val] = mem(i.a) - mem(i.b)
    of "mul":
      regs[i.a.val] = mem(i.a) * mem(i.b)
      result.inc
    of "jnz":
      if mem(i.a) != 0:
        idx += mem(i.b)
        continue
    else:
      assert false
    idx.inc


func composite(n: int): bool =
  for m in 2..(n-1):
    if n mod m == 0:
      return true


func countComposite(b, c, d: int): int =
  for n in countup(b, c, d):
    if n.composite:
      result.inc


let data = parseData()

echo data.runProgram
echo countComposite(109_900, 126_900, 17)
