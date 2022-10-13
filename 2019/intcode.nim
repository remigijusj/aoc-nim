import std/deques
from std/sequtils import toSeq

type Intcode* = object
  data: seq[int]
  iptr: int
  input*: ref Deque[int]
  output*: ref Deque[int]
  halted: bool

type Opcode* = enum
  oAdd         = 1
  oMultiply    = 2
  oInput       = 3
  oOutput      = 4
  oJumpIfTrue  = 5
  oJumpIfFalse = 6
  oLessThan    = 7
  oEquals      = 8
  oHalt        = 99

type Opmode = enum
  mPosition  = 0
  mImmediate = 1

type Op = tuple
  opcode: Opcode
  modes: array[2, Opmode]


proc toIntcode*(data: seq[int]): Intcode =
  result.data = data
  result.input = new Deque[int]
  result.output = new Deque[int]

proc addInput*(ic: var Intcode, values: varargs[int]) =
  for val in values:
    ic.input[].addLast(val)

proc getOutput*(ic: Intcode): seq[int] =
  ic.output[].toSeq

# Pointer in bounds and no halt opcode so far
proc active*(ic: Intcode): bool =
  ic.iptr >= 0 and ic.iptr < ic.data.len and not ic.halted

proc get*(ic: Intcode, delta = 0): int {.inline.} = ic.data[ic.iptr + delta]

proc set*(ic: var Intcode, val: int, idx: int) {.inline.} = ic.data[idx] = val

proc move(ic: var Intcode, delta: int) {.inline.} = ic.iptr.inc(delta)

proc popInput(ic: var Intcode): int {.inline.} = ic.input[].popFirst

proc addOutput(ic: var Intcode, val: int) {.inline.} = ic.output[].addLast(val)


proc parseOp(val: int): Op =
  result.opcode = Opcode(val mod 100) # warning: HoleEnumConv

  var val = val div 100
  for i in 0..1:
    result.modes[i] = Opmode(val mod 10)
    val = val div 10


proc getArg(ic: Intcode, delta: int, op: Op): int =
  let val = ic.get(delta)
  case op.modes[delta - 1]
  of mPosition:
    result = ic.data[val]
  of mImmediate:
    result = val


proc step*(ic: var Intcode): Opcode =
  let op = parseOp(ic.get)
  result = op.opcode
  case op.opcode

  of oAdd:
    ic.set(ic.getArg(1, op) + ic.getArg(2, op), ic.get(3))
    ic.move(4)

  of oMultiply:
    ic.set(ic.getArg(1, op) * ic.getArg(2, op), ic.get(3))
    ic.move(4)

  of oInput:
    ic.set(ic.popInput, ic.get(1))
    ic.move(2)

  of oOutput:
    ic.addOutput(ic.getArg(1, op))
    ic.move(2)

  of oJumpIfTrue:
    if ic.getArg(1, op) != 0:
      ic.iptr = ic.getArg(2, op)
    else:
      ic.move(3)

  of oJumpIfFalse:
    if ic.getArg(1, op) == 0:
      ic.iptr = ic.getArg(2, op)
    else:
      ic.move(3)

  of oLessThan:
    let val = if ic.getArg(1, op) < ic.getArg(2, op): 1 else: 0
    ic.set(val, ic.get(3))
    ic.move(4)

  of oEquals:
    let val = if ic.getArg(1, op) == ic.getArg(2, op): 1 else: 0
    ic.set(val, ic.get(3))
    ic.move(4)

  of oHalt:
    ic.halted = true


# run Intcode program and return memory value at address 0
proc run1*(ic: var Intcode): int =
  while ic.active:
    discard ic.step

  result = ic.data[0]


# run Intcode program and return all outputs
proc run2*(ic: var Intcode, input: varargs[int]): seq[int] =
  ic.addInput(input)

  while ic.active:
    discard ic.step

  result = ic.getOutput
