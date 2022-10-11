import std/[strutils]

type Intcode* = seq[int]


# run Intcode program and return memory value at address 0
proc run1*(ic: var Intcode): int =
  var iptr: int

  while iptr < ic.len:
    case ic[iptr]
    of 1:
      ic[ic[iptr + 3]] = ic[ic[iptr + 1]] + ic[ic[iptr + 2]]
      iptr.inc(4)
    of 2:
      ic[ic[iptr + 3]] = ic[ic[iptr + 1]] * ic[ic[iptr + 2]]
      iptr.inc(4)
    of 99:
      break
    else:
      raise newException(AssertionDefect, format("Invalid code at $#: $#", iptr, ic[iptr]))

  result = ic[0]


proc parseOp(opcode: int): tuple[opcode: int, modes: seq[int]] =
  result.opcode = opcode mod 100
  result.modes = @[result.opcode] # 1st mode is the opcode
  var val = opcode div 100
  while val > 0:
    result.modes.add val mod 10
    val = val div 10
  while result.modes.len < 4:
    result.modes.add 0


proc getArg(ic: Intcode, delta, iptr: int, modes: seq[int]): int =
  let val = ic[iptr + delta]
  case modes[delta]
  of 0: result = ic[val]
  of 1: result = val
  else:
    raise newException(AssertionDefect, format("Invalid opcode mode on $# ($#): $#", iptr, delta, modes[delta]))


# run Intcode program and return outputs list
proc run2*(ic: var Intcode, input: seq[int], debug = false): seq[int] =
  var iptr, inptr: int

  while iptr < ic.len:
    let (opcode, modes) = parseOp(ic[iptr])
    if debug:
      echo (iptr, ic[iptr], opcode, modes, result)

    case opcode
    of 1: # add
      ic[ic[iptr + 3]] = ic.getArg(1, iptr, modes) + ic.getArg(2, iptr, modes)
      iptr.inc(4)
    of 2: # multiply
      ic[ic[iptr + 3]] = ic.getArg(1, iptr, modes) * ic.getArg(2, iptr, modes)
      iptr.inc(4)
    of 3: # input
      ic[ic[iptr + 1]] = input[inptr]
      iptr.inc(2)
      inptr.inc
    of 4: # output
      result.add ic.getArg(1, iptr, modes)
      iptr.inc(2)
    of 5: # jump-if-true
      if ic.getArg(1, iptr, modes) != 0:
        iptr = ic.getArg(2, iptr, modes)
      else:
        iptr.inc(3)
    of 6: # jump-if-false
      if ic.getArg(1, iptr, modes) == 0:
        iptr = ic.getArg(2, iptr, modes)
      else:
        iptr.inc(3)
    of 7: # less than
      let val = if ic.getArg(1, iptr, modes) < ic.getArg(2, iptr, modes): 1 else: 0
      ic[ic[iptr + 3]] = val
      iptr.inc(4)
    of 8: # equals
      let val = if ic.getArg(1, iptr, modes) == ic.getArg(2, iptr, modes): 1 else: 0
      ic[ic[iptr + 3]] = val
      iptr.inc(4)
    of 99: # halt
      break
    else:
      raise newException(AssertionDefect, format("Invalid code at $#: $#", iptr, ic[iptr]))
