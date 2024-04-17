# Advent of Code 2017 - Day 10

import std/[strutils,sequtils,algorithm]
import ../utils/common

type Data = string


proc parseData: Data =
  readInput().strip


func runKnot(data: seq[int], num = 256, rounds = 1): seq[int] =
  result = toSeq(0..<num)
  var cpos = 0
  var skip = 0

  for _ in 1..rounds:
    for size in data:
      if size > 1:
        result.rotateLeft(cpos)
        result.reverse(0, size-1)
        result.rotateLeft(-cpos)
      cpos = (cpos + size + skip) mod result.len
      skip.inc


func knotOnce(data: Data): int =
  let ints = data.split(",").map(parseInt)
  let outs = ints.runKnot
  result = outs[0] * outs[1]


func knotHash*(data: Data): string =
  let ints = data.mapIt(it.ord) & @[17, 31, 73, 47, 23]
  let outs = ints.runKnot(rounds = 64)
  let last = outs.distribute(16).mapIt(it.foldl(a xor b))
  result = last.mapIt(it.chr).join.toHex.toLowerAscii


when isMainModule:
  let data = parseData()

  benchmark:
    echo data.knotOnce
    echo data.knotHash
