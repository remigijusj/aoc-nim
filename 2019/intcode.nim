import std/deques
from std/sequtils import toSeq
from math import `^`

type Intcode* = object
  data:    seq[int]
  iptr:    int
  input*:  ref Deque[int]
  output*: ref Deque[int]
  relbase: int
  halted*:  bool

type Opcode* = enum
  oAdd         = 1
  oMultiply    = 2
  oInput       = 3
  oOutput      = 4
  oJumpIfTrue  = 5
  oJumpIfFalse = 6
  oLessThan    = 7
  oEquals      = 8
  oAddRelBase  = 9
  oHalt        = 99

type Opmode = enum
  mPosition  = 0
  mImmediate = 1
  mRelative  = 2


proc toIntcode*(data: seq[int]): Intcode =
  result.data = data
  result.input = new Deque[int]
  result.output = new Deque[int]


# only external usage
proc getVal*(ic: var Intcode, idx: int): int =
  ic.data[idx]

# only external usage
proc setVal*(ic: var Intcode, val: int, idx: int) =
  ic.data[idx] = val

# only external usage
proc popOutput*(ic: var Intcode): int =
  ic.output[].popLast

proc addInput*(ic: var Intcode, values: varargs[int]) =
  for val in values:
    ic.input[].addLast(val)

proc popInput(ic: var Intcode): int =
  ic.input[].popFirst

proc addOutput(ic: var Intcode, val: int) =
  ic.output[].addLast(val)


proc move(ic: var Intcode, delta: int) {.inline.} =
  ic.iptr.inc(delta)


template mem(offset): int =
  let mode = Opmode((ic.data[ic.iptr] div 10^(offset + 1)) mod 10)
  let pos = case mode
    of mImmediate: ic.iptr + offset
    of mPosition:  ic.data[ic.iptr + offset]
    of mRelative:  ic.data[ic.iptr + offset] + ic.relbase

  ic.data.setLen(max(ic.data.len, pos + 1))
  ic.data[pos]


proc step*(ic: var Intcode): Opcode =
  result = Opcode(ic.data[ic.iptr] mod 100) # warning: HoleEnumConv
  case result

  of oAdd:
    mem(3) = mem(1) + mem(2)
    ic.move(4)

  of oMultiply:
    mem(3) = mem(1) * mem(2)
    ic.move(4)

  of oInput:
    mem(1) = ic.popInput
    ic.move(2)

  of oOutput:
    ic.addOutput(mem(1))
    ic.move(2)

  of oJumpIfTrue:
    if mem(1) != 0:
      ic.iptr = mem(2)
    else:
      ic.move(3)

  of oJumpIfFalse:
    if mem(1) == 0:
      ic.iptr = mem(2)
    else:
      ic.move(3)

  of oLessThan:
    mem(3) = int(mem(1) < mem(2))
    ic.move(4)

  of oEquals:
    mem(3) = int(mem(1) == mem(2))
    ic.move(4)

  of oAddRelBase:
    ic.relbase += mem(1)
    ic.move(2)

  of oHalt:
    ic.halted = true


# run Intcode program and return all outputs
proc run*(ic: var Intcode, input: varargs[int]): seq[int] =
  ic.addInput(input)

  while not ic.halted:
    discard ic.step

  result = ic.output[].toSeq


# convert to Intcode and return it's single output
proc runIntcode*(data: seq[int], input: varargs[int]): int =
  var ic = data.toIntcode
  let output = ic.run(input)
  assert output.len == 1
  result = output[^1]


# run Intcode program until one output and return it
proc getOutput*(ic: var Intcode): int =
  while not ic.halted:
    if ic.step == oOutput:
      return ic.popOutput
