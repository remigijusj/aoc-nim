# Advent of Code 2019 - Day 21

import std/[strutils,sequtils]
import intcode

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

proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").map(parseInt)


proc runIntcode(data: Data, program: string): int =
  var ic = data.toIntcode
  let output = ic.run(program.mapIt(it.ord))
  if output[^1] > 255:
    return output[^1]
  else:
    echo output.mapIt(it.chr).join


proc partOne(data: Data): int = data.runIntcode(part1)
proc partTwo(data: Data): int = data.runIntcode(part2)

let data = parseData("inputs/21.txt")
echo partOne(data)
echo partTwo(data)
