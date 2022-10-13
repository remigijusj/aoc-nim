# Advent of Code 2019 - Day 2

import std/[strutils, sequtils], intcode


type Data = seq[int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(',').mapIt(it.parseInt)


proc initIntcode(data: Data, noun, verb: int): Intcode =
  result = data.toIntcode
  result.setVal(noun, 1)
  result.setVal(verb, 2)


proc partOne(data: Data): int =
  var ic = data.initIntcode(12, 2)
  discard ic.run
  result = ic.getVal(0)


proc partTwo(data: Data): int =
  for noun in 0..99:
    for verb in 0..99:
      var ic = data.initIntcode(noun, verb)
      discard ic.run
      if ic.getVal(0) == 19690720:
        return noun * 100 + verb


let data = parseData("inputs/02.txt")
echo partOne(data)
echo partTwo(data)
