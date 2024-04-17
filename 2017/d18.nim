# Advent of Code 2017 - Day 18

import std/[strutils]
import ../utils/common

type
  RegVal = object
    reg: bool
    val: int

  Instruction = tuple
    op: string
    a, b: RegVal

  Data = tuple
    list: seq[Instruction]
    regs: seq[char]

  Program = object
    binding: seq[int]
    idx: int
    queue: seq[int]
    wait: bool
    sent: int


proc parseRegVal(line: string, regs: var seq[char]): RegVal =
  if line[0] in 'a'..'z':
    if regs.find(line[0]) == -1: regs.add(line[0])
    result = RegVal(reg: true, val: regs.find(line[0]))
  else:
    result = RegVal(reg: false, val: line.parseInt)


proc parseData: Data =
  var i: Instruction
  for line in readInput().strip.splitLines:
    let parts = line.split(" ")
    i.op = parts[0]
    i.a = parts[1].parseRegVal(result.regs)
    if parts.len > 2:
      i.b = parts[2].parseRegVal(result.regs)
    result.list.add(i)


template mem(rv): int =
  if rv.reg:
    binding[rv.val]
  else:
    rv.val


func run1(data: Data): int =
  var binding = newSeq[int](data.regs.len)
  var snd: int
  var idx = 0
  while true:
    let i = data.list[idx]
    case i.op
    of "set":
      binding[i.a.val] = mem(i.b)
    of "add":
      binding[i.a.val] = mem(i.a) + mem(i.b)
    of "mul":
      binding[i.a.val] = mem(i.a) * mem(i.b)
    of "mod":
      binding[i.a.val] = mem(i.a) mod mem(i.b)
    of "snd":
      snd = mem(i.a)
    of "rcv":
      if mem(i.a) != 0:
        return snd
    of "jgz":
      if mem(i.a) > 0:
        idx += mem(i.b)
        continue
    else:
      assert false
    idx.inc


template mem1(rv): int =
  if rv.reg:
    prog[pid].binding[rv.val]
  else:
    rv.val


func run2(data: Data): int =
  var prog: array[2, Program]
  for pid in [0, 1]:
    prog[pid].binding.setLen(data.regs.len)
    prog[pid].binding[data.regs.find('p')] = pid

  while true:
    for pid in [0, 1]:
      if prog[0].wait and prog[1].wait:
        return prog[1].sent
      if prog[pid].wait:
        continue

      let i = data.list[prog[pid].idx]
      var step = 1

      case i.op
      of "set":
        prog[pid].binding[i.a.val] = mem1(i.b)
      of "add":
        prog[pid].binding[i.a.val] = mem1(i.a) + mem1(i.b)
      of "mul":
        prog[pid].binding[i.a.val] = mem1(i.a) * mem1(i.b)
      of "mod":
        prog[pid].binding[i.a.val] = mem1(i.a) mod mem1(i.b)
      of "snd":
        let val = mem1(i.a)
        prog[1-pid].queue.add(val)
        prog[1-pid].wait = false
        prog[pid].sent.inc
      of "rcv":
        if prog[pid].queue.len > 0:
          let val = prog[pid].queue[0]
          prog[pid].queue.delete(0)
          prog[pid].binding[i.a.val] = val
        else:
          prog[pid].wait = true
          step = 0
      of "jgz":
        if mem1(i.a) > 0:
          step = mem1(i.b)
      else: assert false
      prog[pid].idx.inc(step)


let data = parseData()

benchmark:
  echo data.run1
  echo data.run2
