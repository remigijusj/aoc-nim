# Advent of Code 2018 - Day 16

import std/[strscans,strutils,sequtils,sets]
import ../utils/common

type
  Regs = array[4, int]

  Instr = tuple[opcode, A, B, C: int]

  Sample = tuple
    before: Regs
    instr: Instr
    after: Regs

  Data = object
    samples: seq[Sample]
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

var ops = [adds, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]


func parseInstr(line: string): Instr =
  assert line.scanf("$i $i $i $i", result.opcode, result.A, result.B, result.C)


func parseSample(line: string): Sample =
  let parts = line.split("\n")
  assert parts[0].scanf("Before: [$i, $i, $i, $i]",
    result.before[0], result.before[1], result.before[2], result.before[3])
  result.instr = parts[1].parseInstr
  assert parts[2].scanf("After:  [$i, $i, $i, $i]",
    result.after[0], result.after[1], result.after[2], result.after[3])


proc parseData: Data =
  let parts = readInput().strip.split("\n\n\n\n")
  result.samples = parts[0].split("\n\n").map(parseSample)
  result.lines = parts[1].splitLines.map(parseInstr)


proc fitsOpcodes(sample: Sample): seq[int] =
  for i, op in ops:
    var regs = sample.before
    op(regs, sample.instr)
    if regs == sample.after: result.add(i)


proc matchOpcodes(samples: seq[Sample]): array[16, HashSet[int]] =
  for i in 0..<16:
    result[i] = (0..15).toSeq.toHashSet

  for sample in samples:
    let opcode = sample.instr.opcode
    let fits = sample.fitsOpcodes.toHashSet
    result[opcode] = result[opcode] * fits


proc resolve(matches: array[16, HashSet[int]]): array[16, int] =
  var matches = matches
  var resolved = 0
  while resolved < result.len:
    for k, this in matches.mpairs:
      if this.card == 1:
        result[k] = this.pop
        for other in matches.mitems:
          other.excl(result[k])
        resolved.inc


proc run(opindex: array[16, int], lines: seq[Instr]): Regs =
  for line in lines:
    let op = ops[opindex[line.opcode]]
    op(result, line)


let data = parseData()

benchmark:
  echo data.samples.countIt(it.fitsOpcodes.len >= 3)
  echo data.samples.matchOpcodes.resolve.run(data.lines)[0]
