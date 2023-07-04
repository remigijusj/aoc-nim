# Advent of Code 2017 - Day 8

import std/[strscans,strutils,sequtils,tables]

type
  Instruction = tuple
    reg: string
    amt: int
    creg: string
    cond: string
    camt: int

  Data = seq[Instruction]

  Regs = CountTable[string]


func parseInstruction(line: string): Instruction =
  var op: string
  assert line.scanf("$+ $+ $i if $+ $+ $i", result.reg, op, result.amt, result.creg, result.cond, result.camt)
  assert op in ["inc", "dec"]
  if op == "dec": result.amt *= -1


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInstruction)


func satisfy(val: int, it: Instruction): bool =
  case it.cond
    of ">":  return val > it.camt
    of "<":  return val < it.camt
    of ">=": return val >= it.camt
    of "<=": return val <= it.camt
    of "==": return val == it.camt
    of "!=": return val != it.camt
    else: assert false


func runInstructions(data: Data): tuple[regs: Regs, maxv: int] =
  for it in data:
    if result.regs[it.creg].satisfy(it):
      result.regs.inc(it.reg, it.amt)
      let val = result.regs[it.reg]
      if val > result.maxv: result.maxv = val


let data = parseData()
let (regs, maxv) = data.runInstructions

echo regs.largest.val
echo maxv
