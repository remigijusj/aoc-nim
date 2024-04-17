# Advent of Code 2019 - Day 5

import std/[strutils, sequtils]
import intcode
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(',').mapIt(it.parseInt)


proc diagnosticCode(data: Data): int =
  var ic = data.toIntcode
  let output = ic.run(1)
  for i in 0..output.len-2:
    assert output[i] == 0
  return output[^1]


let data = parseData()

benchmark:
  echo data.diagnosticCode
  echo data.runIntcode(5)
