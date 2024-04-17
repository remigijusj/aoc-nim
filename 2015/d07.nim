# Advent of Code 2015 - Day 7

import std/[strutils,sequtils,tables]
import ../utils/common
import memo

type
  Input = tuple
    gate: string
    val: int

  Wire = tuple
    in1, in2: Input
    op, to: string

  Data = Table[string, Wire]


func parseInput(line: string): Input =
  if line[0].isDigit:
    result = ("", line.parseInt)
  else:
    result = (line, 0)


func parseWire(line: string): Wire =
  let parts = line.split(" ")
  if parts.len == 3:
    result.in1 = parts[0].parseInput
  elif parts.len == 4:
    result.op = parts[0]
    result.in1 = parts[1].parseInput
  elif parts.len == 5:
    result.in1 = parts[0].parseInput
    result.op = parts[1]
    result.in2 = parts[2].parseInput
  else:
    assert false
  assert parts[^2] == "->"
  result.to = parts[^1]


proc parseData: Data =
  let wires = readInput().strip.splitLines.map(parseWire)
  for wire in wires:
    result[wire.to] = wire


func eval(data: Data, input: Input): uint16 {.memoized.} =
  if input.gate == "":
    return input.val.uint16

  let wire = data[input.gate]
  if wire.op == "":
    result = data.eval(wire.in1)
  elif wire.op == "NOT":
    result = not data.eval(wire.in1)
  elif wire.op == "AND":
    result = data.eval(wire.in1) and data.eval(wire.in2)
  elif wire.op == "OR":
    result = data.eval(wire.in1) or data.eval(wire.in2)
  elif wire.op == "RSHIFT":
    result = data.eval(wire.in1) shr wire.in2.val
  elif wire.op == "LSHIFT":
    result = data.eval(wire.in1) shl wire.in2.val
  else:
    assert false


proc eval2(data: Data, input: Input): uint16 =
  let a1 = data.eval(input)
  var data1 = data
  var b: Wire
  b.in1 = ("", a1.int)
  data1["b"] = b
  result = data1.eval(input)


let data = parseData()

benchmark:
  echo data.eval(("a", 0))
  echo data.eval2(("a", 0))
