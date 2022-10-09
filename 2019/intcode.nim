import strutils

type Intcode* = seq[int]


# run Intcode program and return memory value at address 0
proc run*(ic: var Intcode): int =
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

  ic[0]
