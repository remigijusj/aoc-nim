# Advent of Code 2019 - Day 25

import std/[strutils,sequtils]
import intcode
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


proc interactiveLoop(data: Data) =
  var ic = data.toIntcode
  var input: string

  while not ic.halted:
    let output = ic.run(input.mapIt(it.ord)).mapIt(it.chr).join
    stdout.write(output)
    input = stdin.readLine & "\n"


let data = parseData()

benchmark:
  data.interactiveLoop
