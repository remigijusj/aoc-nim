# Advent of Code 2024 - Day 24

import std/[strscans,strformat,strutils,sequtils,tables,algorithm]
import ../utils/common

type
  Op = enum
    AND, XOR, OR

  Gate = tuple
    i1, i2: string
    op: Op

  Gates = Table[string, Gate]

  Values = Table[string, bool]

  Data = tuple
    input: Values
    gates: Gates


const
  size = 45 # 00..44/45


func parseInput(line: string): (string, bool) =
  var val: int
  assert line.scanf("$+: $i", result[0], val)
  assert val in [0, 1]
  result[1] = (val == 1)


func parseGate(line: string): (string, Gate) =
  var op: string
  assert line.scanf("$+ $+ $+ -> $+", result[1].i1, op, result[1].i2, result[0])
  result[1].op = parseEnum[Op](op)


proc parseData: Data =
  let parts = readInput().strip.split("\n\n", 2)
  result.input = parts[0].split("\n").mapIt(it.parseInput).toTable
  result.gates = parts[1].split("\n").mapIt(it.parseGate).toTable


func eval(gate: Gate, val1, val2: bool): bool =
  case gate.op
  of AND: result = val1 and val2
  of XOR: result = val1 xor val2
  of OR:  result = val1  or val2


func simulate(gates: Gates, input: Values): Values =
  result = input
  var advance = true
  while advance:
    advance = false
    for name, gate in gates:
      if name notin result and gate.i1 in result and gate.i2 in result:
        result[name] = gate.eval(result[gate.i1], result[gate.i2])
        advance = true


func toInteger(values: Values): int =
  for i in countdown(size, 0):
    result *= 2
    if values[&"z{i:02}"]: result.inc


proc findIncorrect(gates: Gates): seq[string] =
  for name, gate in gates:
    case gate.op
    of AND:
      if gate.i1 == "x00" or gate.i2 == "x00":
        continue
      if name[0] == 'z' and name != &"z{size:02}":
        result.add(name)
      for next in gates.values:
        if (name == next.i1 or name == next.i2) and next.op != OR:
          result.add(name)

    of XOR:
      if name[0] notin "xyz" and gate.i1[0] notin "xyz" and gate.i2[0] notin "xyz":
        result.add(name)
      for next in gates.values:
        if (name == next.i1 or name == next.i2) and next.op == OR:
          result.add(name)

    of OR:
      if name[0] == 'z' and name != &"z{size:02}":
        result.add(name)


let data = parseData()

benchmark:
  echo data.gates.simulate(data.input).toInteger
  echo data.gates.findIncorrect.deduplicate.sorted.join(",")
