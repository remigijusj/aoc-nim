# Advent of Code 2019 - Day 21

import std/[strutils,sequtils]
import intcode
import ../utils/common

type Data = seq[int]

# !(A ^ B ^ C) ^ D
const part1 = """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
WALK
"""

# !((!H v C) ^ (A ^ B)) ^ D = ((H ^ !C) v !(A ^ B)) ^ D
const part2 = """
NOT H T
OR C T
AND A T
AND B T
NOT T J
AND D J
RUN
"""

proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


proc runIntcode(data: Data, program: string): int =
  var ic = data.toIntcode
  let output = ic.run(program.mapIt(it.ord))
  if output[^1] > 255:
    return output[^1]
  else:
    echo output.mapIt(it.chr).join


let data = parseData()

benchmark:
  echo data.runIntcode(part1)
  echo data.runIntcode(part2)
