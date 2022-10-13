# Advent of Code 2019 - Day 2

import std/[strutils, sequtils], intcode


type Data = seq[int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(',').mapIt(it.parseInt)


proc initIntcode(data: Data, noun, verb: int): Intcode =
  result = data.toIntcode
  result.set(noun, 1)
  result.set(verb, 2)


proc partOne(data: Data): int =
  var ic = data.initIntcode(12, 2)
  return ic.run1


proc partTwo(data: Data): int =
  for noun in 0..99:
    for verb in 0..99:
      var ic = data.initIntcode(noun, verb)
      if ic.run1 == 19690720:
        return noun * 100 + verb


let data = parseData("inputs/02.txt")
echo partOne(data)
echo partTwo(data)
