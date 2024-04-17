# Advent of Code 2018 - Day 19

import std/[strscans,strutils,sequtils,tables]
from math import sqrt
import ../utils/common

type
  Regs = array[6, int]

  Instr = tuple
    opcode: string
    A, B, C: int

  Data = object
    ip: int
    lines: seq[Instr]

proc adds(r: var Regs, i: Instr) = r[i.C] =    r[i.A] +   r[i.B]
proc addi(r: var Regs, i: Instr) = r[i.C] =    r[i.A] +     i.B
proc mulr(r: var Regs, i: Instr) = r[i.C] =    r[i.A] *   r[i.B]
proc muli(r: var Regs, i: Instr) = r[i.C] =    r[i.A] *     i.B
proc banr(r: var Regs, i: Instr) = r[i.C] =    r[i.A] and r[i.B]
proc bani(r: var Regs, i: Instr) = r[i.C] =    r[i.A] and   i.B
proc borr(r: var Regs, i: Instr) = r[i.C] =    r[i.A] or  r[i.B]
proc bori(r: var Regs, i: Instr) = r[i.C] =    r[i.A] or    i.B
proc setr(r: var Regs, i: Instr) = r[i.C] =    r[i.A]
proc seti(r: var Regs, i: Instr) = r[i.C] =      i.A
proc gtir(r: var Regs, i: Instr) = r[i.C] = if   i.A  >   r[i.B]: 1 else: 0
proc gtri(r: var Regs, i: Instr) = r[i.C] = if r[i.A] >     i.B:  1 else: 0
proc gtrr(r: var Regs, i: Instr) = r[i.C] = if r[i.A] >   r[i.B]: 1 else: 0
proc eqir(r: var Regs, i: Instr) = r[i.C] = if   i.A  ==  r[i.B]: 1 else: 0
proc eqri(r: var Regs, i: Instr) = r[i.C] = if r[i.A] ==    i.B:  1 else: 0
proc eqrr(r: var Regs, i: Instr) = r[i.C] = if r[i.A] ==  r[i.B]: 1 else: 0

var ops = {
  "addr": adds, "addi": addi, "mulr": mulr, "muli": muli, "banr": banr, "bani": bani, "borr": borr, "bori": bori, 
  "setr": setr, "seti": seti, "gtir": gtir, "gtri": gtri, "gtrr": gtrr, "eqir": eqir, "eqri": eqri, "eqrr": eqrr,
}.toTable


func parseInstr(line: string): Instr=
  assert line.scanf("$+ $i $i $i", result.opcode, result.A, result.B, result.C)


proc parseData: Data =
  let lines = readInput().strip.splitLines
  assert lines[0].scanf("#ip $i", result.ip)
  result.lines = lines[1..^1].map(parseInstr)


proc run(data: Data, init: Regs): Regs =
  result = init
  var ip = 0
  while ip in 0..<data.lines.len:
    let line = data.lines[ip]
    let op = ops[line.opcode]
    swap(result[data.ip], ip)
    op(result, line)
    swap(result[data.ip], ip)
    ip.inc


proc sumOfDivisors(n: int): int =
  for k in 1 .. sqrt(n.float).int:
    if n mod k == 0:
      result += k
      let l = n div k
      if l != k:
        result += l


let data = parseData()

benchmark:
  echo data.run([0, 0, 0, 0, 0, 0])[0]
  # echo data.run([1, 0, 0, 0, 0, 0])[0]
  echo sumOfDivisors(10551319)
