# Advent of Code 2024 - Day 17

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Regs = array[3, int]

  Program = seq[int]

  Data = tuple
    regs: Regs
    program: Program

func `$`(p: Program): string = p.mapIt($it).join(",")


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  assert parts[0].scanf("Register A: $i\nRegister B: $i\nRegister C: $i",
                        result.regs[0], result.regs[1], result.regs[2])
  result.program = parts[1][9..^1].split(',').map(parseInt)


func combo(regs: Regs, val: int): int =
  assert val in 0..6
  if val in 0..3:
    result = val
  else:
    result = regs[val-4]


func getOutput(data: Data): seq[int] =
  var ip = 0
  var regs = data.regs
  while true:
    if ip < 0 or ip > data.program.len-2:
      break
    let op = data.program[ip]
    let arg = data.program[ip+1]
    assert arg in 0..7

    case op
    of 0: # adv
      regs[0] = regs[0] shr combo(regs, arg)
    of 1: # bxl
      regs[1] = regs[1] xor arg
    of 2: # bst
      regs[1] = combo(regs, arg) mod 8
    of 3: # jnz
      if regs[0] != 0:
        ip = arg
        continue
    of 4: # bxc
      regs[1] = regs[1] xor regs[2]
    of 5: # out
      result.add(combo(regs, arg) mod 8)
    of 6: # bdv
      regs[1] = regs[0] shr combo(regs, arg)
    of 7: # cdv
      regs[2] = regs[0] shr combo(regs, arg)
    else:
      assert false

    ip.inc(2)


# Simplified, for testing
func getOutput2(init: int): seq[int] =
  var a = init
  while a > 0:
    let b = a mod 8
    let c = a shr (b xor 1)
    let o = (b xor 4 xor c) and 7
    result.add(o)
    a = a div 8


# Backtracking search, backwards by 3-bit chunks
func findQuine(prog: Program, a = 0, i = 1): int =
  if i > prog.len:
    assert getOutput2(a) == prog
    return a
  for b in 0..7:
    let a1 = a * 8 + b
    let c = a1 shr (b xor 1)
    let o = (b xor 4 xor c) and 7
    if o == prog[^i]:
      let next = prog.findQuine(a1, i+1)
      if next > 0:
        return next


let data = parseData()

benchmark:
  echo data.getOutput
  echo data.program.findQuine
