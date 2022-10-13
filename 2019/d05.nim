# Advent of Code 2019 - Day 5

import std/[strutils, sequtils], intcode

type Data = seq[int]

proc parseData(filename: string): Data =
  readFile(filename).strip.split(',').mapIt(it.parseInt)


proc partOne(data: Data): int =
  var ic = data.toIntcode
  let output = ic.run(1)
  for i in 0..output.len-2:
    assert output[i] == 0
  return output[^1]


proc partTwo(data: Data): int = runIntcode(data, 5)

let data = parseData("inputs/05.txt")
echo partOne(data)
echo partTwo(data)
